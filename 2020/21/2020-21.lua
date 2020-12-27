
tds = [[
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)]]

print(tds)

function read_data(inp)
    ings = {}
    algs = {}
    for istr,astr in inp:gmatch("(.-) %(contains (.-)%)\n") do
        is = {}
        for ing in istr:gmatch("(%w+)") do
            table.insert(is, ing)
        end
        table.insert(ings, is)

        as = {}
        for alg in astr:gmatch("(%w+)") do
            table.insert(as, alg)
        end
        table.insert(algs, as)
    end
    return ings,algs
end


ings,algs = read_data(tds)
for i,is in ipairs(ings) do
    print(i, "Ingredients:", table.concat(ings[i],","), "Allergens:", table.concat(algs[i],","))
end

