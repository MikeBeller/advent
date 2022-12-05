
# store all the lines in the file "tinput.txt" in a list with newlines removed
lines = [line.rstrip() for line in open("input.txt")]

# split each line into two halves at index len/2
# and store in a list of tuples
p1data = [(line[:len(line)//2], line[len(line)//2:]) for line in lines]

# for each pair, find the one common character using python set objects
# and store the resulting set in a list
common = [set(a) & set(b) for a, b in p1data]

# make a list of all the lowercase letters and then all the uppercase letters and assign it to "alphabet"
alphabet = list("abcdefghijklmnopqrstuvwxyz") + list("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

def priority(c):
    """Return a priority value for the given character."""
    # return the index of the character in the alphabet
    return alphabet.index(c) + 1

# find the sum of the sum of the priorities of the characters in each set
print(sum(sum(priority(c) for c in s) for s in common))

# group the lines into groups of 3 and assign it to "p2data"
p2data = [lines[i:i+3] for i in range(0, len(lines), 3)]

# for each group of 3, find the one common character using python set objects
# and store the resulting set in a list
common = [set(a) & set(b) & set(c) for a, b, c in p2data]

# find the sum of the sum of the priorities of the characters in each set
print(sum(sum(priority(c) for c in s) for s in common))
