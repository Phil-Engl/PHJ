import random
import mmh3
import numpy as np


ROW_BITS = 21
wanted_per_ht = 1000
wanted_dummy_build = 0
wanted_dummy_probe = 0

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
output_dummy = [[],[],[],[],[],[],[],[]]#[]
used_keys = []

used_IDs = set()

for i in range(8):
    used_keys.append(set())

i = 0

while len(build_tuples_dummy[0]) < wanted_per_ht:
    Key, Key_hex = generate_hex_number()
    murmur3_hash_int = mmh3.hash(b'', Key)
    row_index = get_row(murmur3_hash_int, ROW_BITS)
    ht_index = get_ht(murmur3_hash_int)
    if ht_index == 0:

        if (arr[ht_index][row_index] < 4) and not (Key in used_keys[ht_index]):
            if len(build_tuples_dummy[ht_index]) < wanted_per_ht:
                used_keys[ht_index].add(Key)
                arr[ht_index][row_index] = arr[ht_index][row_index] + 1

                ID1, ID1_hex = generate_hex_number()
                ID2, ID2_hex = generate_hex_number()

                while (ID1 in used_IDs):
                    ID1, ID1_hex = generate_hex_number()

                while (ID2 in used_IDs):
                    ID2, ID2_hex = generate_hex_number()

                used_IDs.add(ID1)
                used_IDs.add(ID2)
                build_tuples_dummy[ht_index].append(ID1_hex + Key_hex)
                probe_tuples_dummy[ht_index].append(ID2_hex + Key_hex)
                output_dummy[ht_index].append(ID1_hex + Key_hex + ID2_hex + Key_hex)
                i = i+1
                #print(i, "/", wanted_per_ht * 8)


for i in range(8):
    if len(build_tuples_dummy[i]) == wanted_per_ht:
        build_list = split_list(build_tuples_dummy[i], 8)
        probe_list = split_list(probe_tuples_dummy[i], 8)
        write_list_to_file("reference_output.txt", output_dummy[i])
        for i in range(8):
            write_list_to_file(f"build_tuples_{i}.txt", build_list[i])
            write_list_to_file(f"probe_tuples_{i}.txt", probe_list[i])
        return

