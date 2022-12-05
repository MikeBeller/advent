
# store all the lines in the file "tinput.txt" in a list with newlines removed
lines = [line.rstrip() for line in open("tinput.txt")]

# split each line into two halves at index len/2
# and store in a list of tuples
lines = [(line[:len(line)//2], line[len(line)//2:]) for line in lines]

# for each pair, find the one common character using python set objects
# and store the resulting set in a list
common = [set(a) & set(b) for a, b in lines]

def priority(c):
    """Return a priority value for the given character."""
    # return the index of the character in the alphabet
    return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".index(c) + 1

# find the sum of the sum of the priorities of the characters in each set
print(sum(sum(priority(c) for c in s) for s in common))
