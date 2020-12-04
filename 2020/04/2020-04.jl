read_data(inp) =
    collect(Dict(split(w,":") for w in
         split(line)) for line in
         split(strip(inp), "\n\n"))

test_data = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in"""

function part1(inp)
    passports = read_data(inp)
    reqd = Set(["byr","iyr","eyr","hgt","hcl","ecl","pid"])
    count(passports) do p
        length(setdiff(reqd, Set(keys(p)))) == 0
    end
end

@assert part1(test_data) == 2

inp = read("input.txt", String)
println("PART1: ", part1(inp))

function checkyr(s, mn, mx)
    m = match(r"^\d\d\d\d$", s)
    if m === nothing return false end
    n = parse(Int, m.match)
    n >= mn && n <= mx
end

function checkhgt(hgt)
    m = match(r"(\d+)(in|cm)", hgt)
    if m === nothing return false end

    n = parse(Int, m.captures[1])
    if m.captures[2] == "cm"
        n >= 150 && n <= 193
    else
        n >= 59 && n <= 76
    end
end

checkhcl(s) = occursin(r"^#[0-9a-f]{6}$", s)
checkecl(s) = occursin(r"^(amb|blu|brn|gry|grn|hzl|oth)$", s)
checkpid(s) = occursin(r"^\d{9}$", s)
checkcid(s) = true

validate = Dict(
                "byr" => f -> checkyr(f, 1920, 2002),
                "iyr" => f -> checkyr(f, 2010, 2020),
                "eyr" => f -> checkyr(f, 2020, 2030),
                "hgt" => checkhgt,
                "hcl" => checkhcl,
                "ecl" => checkecl,
                "pid" => checkpid,
                "cid" => checkcid,
)

function valid(p)
    all(validate[f](get(p, f, ""))
        for f in ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
end

tests = """
byr valid:   2002
byr invalid: 2003
hgt valid:   60in
hgt valid:   190cm
hgt invalid: 190in
hgt invalid: 190
hcl valid:   #123abc
hcl invalid: #123abz
hcl invalid: 123abc
ecl valid:   brn
ecl invalid: wat
pid valid:   000000001
pid invalid: 0123456789
"""

for line in split(strip(tests), "\n")
    (f, res, v) = split(line)
    val = validate[f](v)
    if (res == "valid:" && !val) || (res == "invalid:" && val)
        println("test: $(line) failed")
        @assert false
    end
end

invalid_pports = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
"""

@assert all(!valid(p) for p in read_data(invalid_pports))

valid_pports = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
"""
@assert all(valid(p) for p in read_data(valid_pports))

part2(inp) = count(valid(p) for p in read_data(inp))
println("PART2: ", part2(inp))

