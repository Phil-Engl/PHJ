import random
import mmh3
import numpy as np


ROW_BITS = 21
wanted_valid_tuples = 8000
wanted_dummy_build = 0
wanted_dummy_probe = 0

wanted_per_ht = wanted_valid_tuples / 8
rows = 2**ROW_BITS
num_tables = 8

def split_list(lst, num_parts):
    parts = np.array_split(lst, num_parts)
    return parts

def write_list_to_file(filename, data_list):
    with open(filename, 'w') as file:
        for element in data_list:
            file.write(f"{element}\n")

def generate_hex_number():
    number = random.randint(0, 0xFFFFFFFF) 
    as_hex = f"{number:08X}"
    return  (number, as_hex) 

def get_row(number, n):
    mask = (1 << n) - 1
    last_n_bits = number & mask
    return last_n_bits

def get_ht(hash_int):
    shifted_int = (hash_int >> 29) & 0b111
    return shifted_int

arr = [[0]*rows for _ in range(num_tables)]

build_tuples_dummy = [[],[],[],[],[],[],[],[]]
probe_tuples_dummy = [[],[],[],[],[],[],[],[]]
output_dummy = []
used_keys = set()

i = 0

while len(build_tuples_dummy[0]) < wanted_per_ht or  len(build_tuples_dummy[1]) < wanted_per_ht or len(build_tuples_dummy[2]) < wanted_per_ht or len(build_tuples_dummy[3]) < wanted_per_ht or len(build_tuples_dummy[4]) < wanted_per_ht or len(build_tuples_dummy[5]) < wanted_per_ht or len(build_tuples_dummy[6]) < wanted_per_ht or len(build_tuples_dummy[7]) < wanted_per_ht:
    Key, Key_hex = generate_hex_number()
    murmur3_hash_int = mmh3.hash(b'', Key)
    row_index = get_row(murmur3_hash_int, ROW_BITS)
    ht_index = get_ht(murmur3_hash_int)

    if (arr[ht_index][row_index] < 4) and not (Key in used_keys):
        if len(build_tuples_dummy[ht_index]) < wanted_per_ht:
            used_keys.add(Key)
            arr[ht_index][row_index] = arr[ht_index][row_index] + 1

            ID1, ID1_hex = generate_hex_number()
            ID2, ID2_hex = generate_hex_number()

            build_tuples_dummy[ht_index].append(ID1_hex + Key_hex)
            probe_tuples_dummy[ht_index].append(ID2_hex + Key_hex)
            output_dummy.append(ID1_hex + Key_hex + ID2_hex + Key_hex)
            i = i+1
            #print(i, "/", wanted_per_ht * 8)

write_list_to_file("reference_output.txt", output_dummy)

write_list_to_file(f"build_tuples_0.txt", build_tuples_dummy[0])
write_list_to_file(f"build_tuples_1.txt", build_tuples_dummy[4])
write_list_to_file(f"build_tuples_2.txt", build_tuples_dummy[2])
write_list_to_file(f"build_tuples_3.txt", build_tuples_dummy[6])
write_list_to_file(f"build_tuples_4.txt", build_tuples_dummy[1])
write_list_to_file(f"build_tuples_5.txt", build_tuples_dummy[5])
write_list_to_file(f"build_tuples_6.txt", build_tuples_dummy[3])
write_list_to_file(f"build_tuples_7.txt", build_tuples_dummy[7])

write_list_to_file(f"probe_tuples_0.txt", probe_tuples_dummy[0])
write_list_to_file(f"probe_tuples_1.txt", probe_tuples_dummy[4])
write_list_to_file(f"probe_tuples_2.txt", probe_tuples_dummy[2])
write_list_to_file(f"probe_tuples_3.txt", probe_tuples_dummy[6])
write_list_to_file(f"probe_tuples_4.txt", probe_tuples_dummy[1])
write_list_to_file(f"probe_tuples_5.txt", probe_tuples_dummy[5])
write_list_to_file(f"probe_tuples_6.txt", probe_tuples_dummy[3])
write_list_to_file(f"probe_tuples_7.txt", probe_tuples_dummy[7])

