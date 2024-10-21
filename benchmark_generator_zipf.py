import random
import mmh3
import numpy as np




# Verwend skew als measurement. Nimm a verteilung ah wia die tuples uf die hash tables gematched wörran. e.g perfectly distributed, to all-in-one distributed.
# compare resultes mit mindestens einem cpu system. schau dassd a cpu entwerder ufm alveo-cluster kriagsch oda falls as ned allzu compute-intense isch kannschas uf build server laufa lo...
# Gib da throughput in tuples/sek und ned in tuples/cycle ah..!
# Gib bei da waveform vu da simulation die MUX hinzu.





# Nimm nur 8mil....
# 1perfekter datensatz
# 1 zufälliger
# 1 Worst case datensatz (all in same hashtable)

# Report soll zwischen 20 und 30 seiten sein..!
# Schick am jonas VOR am nägsten meeting was du gschrieba hasch. schau dass die plots und grafiken fertig hash..!

# Falls perfekter datensatz => perfekte perf: dann versuch noch 8 auf 16 NW implementiera
# Falls nicht => beheb fehler

#  1. Intro: motivation. (schau wies die andren hash-join papers motivieren)
            # erklär das problem des du läsen wit
            # darfsch erwähnen dass des nur die basis isch vu nam grösseren projekt (masterarbeit).
            # Kannsch oh biz was über ACCL schrieba...
            # für partitionierung hats scho a paper/implementierung. Hash join no ned => had to do myself...
            # was hasch gmacht, vorschlag für lösung, contribution von der arbeit etc... (kurzüberblick vum ganzer paper)
            # outline vum rest von der arbeit. (sek2 machma des und des. sek3 des und des, etc.)
# 2. background and related work (max 5 seiten von 20!)
    # was sind distributed joins. (hash joins, redix-sort joins etc.) (why we use hash joins & describe hash joins und hashtables im detail.)
    # kannsch untersektion macha wo du allgemein über FPGA's redesch. 
    # vlt a biz was zu hashes und murmur-hash
    # check google scholar für related work..! (was gibt es wie related work und wie steht sie im verhältnis zu dem was ih gmacht han.)
    #                           e.g für partitioning gits scho paper/implementation  und die passiert hald vor dinam join.

# 3. concept
    # Phils-hash-table: overview of whole system.
    # mux
    # hashtable 
    # etc...

# 4. Evaluation.   
    # Setup, datensätze etc. 
    # Messungen (plots..!)
    # Tuples/sek.!

# 5. Conclusion & future work:
    # kannsch sega was noch fehlt und wia me des lösen kann



ROW_BITS = 21
insert_total = 8000000
zipf_z = 2


#wanted_valid_tuples = 50000000
#wanted_dummy_build = 0#2000
#wanted_dummy_probe = 0#2000

rows = 2**ROW_BITS
num_tables = 8



def get_zipf(N_elements, z):
    elements_per_set = []
    distribution_sum = 0
    total_elements = 0

    for k_rank in range(1,9):
        sum = 0
        for n in range(1, N_elements):
            sum = sum + 1/(n**z)

        distribution_sum = distribution_sum + (1/(k_rank**z))/sum


    for k_rank in range(1,9):

        sum = 0
        for n in range(1, N_elements):
            sum = sum + 1/(n**z)

        elements_at_k_rank = round((N_elements/(k_rank**z))/(sum * distribution_sum))

        elements_per_set.append(elements_at_k_rank)

        #print(k_rank, end="|")
        #print(elements_at_k_rank)

        total_elements = total_elements + elements_at_k_rank


    #print("\nSum of all elements accounted for so far, to make sure we're at 1,000,000")
    print(elements_per_set)
    print(total_elements)
    return total_elements, elements_per_set

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

build_tuples_valid = []
probe_tuples_valid = []
#reference_output = []

build_tuples_dummy = [[],[],[],[],[],[],[],[]]
probe_tuples_dummy = [[],[],[],[],[],[],[],[]]
output_dummy = []
used_keys = set()#[]

insert_total, wanted_per_ht = get_zipf(insert_total, zipf_z)

i = 0

while len(build_tuples_dummy[0]) < wanted_per_ht[0] or  len(build_tuples_dummy[1]) < wanted_per_ht[1] or len(build_tuples_dummy[2]) < wanted_per_ht[2] or len(build_tuples_dummy[3]) < wanted_per_ht[3] or len(build_tuples_dummy[4]) < wanted_per_ht[4] or len(build_tuples_dummy[5]) < wanted_per_ht[5] or len(build_tuples_dummy[6]) < wanted_per_ht[6] or len(build_tuples_dummy[7]) < wanted_per_ht[7]:
    Key, Key_hex = generate_hex_number()
    murmur3_hash_int = mmh3.hash(b'', Key)
    row_index = get_row(murmur3_hash_int, ROW_BITS)
    ht_index = get_ht(murmur3_hash_int)

    if (arr[ht_index][row_index] < 4) and not (Key in used_keys):
        if len(build_tuples_dummy[ht_index]) < wanted_per_ht[ht_index]:
            used_keys.add(Key)
            arr[ht_index][row_index] = arr[ht_index][row_index] + 1

            ID1, ID1_hex = generate_hex_number()
            ID2, ID2_hex = generate_hex_number()

            build_tuples_dummy[ht_index].append(ID1_hex + Key_hex)
            probe_tuples_dummy[ht_index].append(ID2_hex + Key_hex)
            output_dummy.append(ID1_hex + Key_hex + ID2_hex + Key_hex)
            i = i+1
            if(i % 500000 == 0):
                print(i, "/", insert_total)


write_list_to_file("reference_output.txt", output_dummy)

for i in range(8):
    build_tuples_valid = build_tuples_valid + build_tuples_dummy[i]
    probe_tuples_valid = probe_tuples_valid + probe_tuples_dummy[i]




random.shuffle(build_tuples_valid)
random.shuffle(probe_tuples_valid)


split_build = split_list(build_tuples_valid, 8)

i = 0
for partial_list in split_build:
    write_list_to_file(f"build_tuples_{i}.txt", partial_list)
    i = i+1

split_probe = split_list(probe_tuples_valid, 8)

i = 0
for partial_list in split_probe:
    write_list_to_file(f"probe_tuples_{i}.txt", partial_list)
    i = i+1

