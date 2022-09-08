const DIR_OF_TXTS = "data/state_union_raw"

dir_files = readdir(DIR_OF_TXTS)
txt_files = [f for f in dir_files if occursin(".txt", f)]

function tokenize(filename)
    #Naive tokenization scheme
    doc_as_string = open(f->read(f, String), string(DIR_OF_TXTS, "/", filename))
    doc_as_string = replace(doc_as_string, r"[^\w+]" => " ")
    doc_as_string = replace(doc_as_string, r"\s+" => " ")
    doc_as_string = lowercase(doc_as_string)
    return(split(doc_as_string))
end

#construct vocab
vocab = Dict()


for txt_file in txt_files
    tokens = tokenize(txt_file)
    for token in tokens
        if !in(token, keys(vocab))
            vocab[token] = (length(vocab) + 1, 1)
        else
            a, b = vocab[token]
            vocab[token] = (a, b+1)
        end
    end
    print(string("\ndid ", txt_file))
    print(length(vocab))
end

println("\nLength of unpruned vocab: ", length(vocab))
top_vocab = Dict()
for key in keys(vocab)
    if vocab[key][2] > 20
        top_vocab[key] = length(top_vocab) + 1
    end
end
print("Length of pruned vocab: ", length(top_vocab))

"""
Build nHotVector type
"""

struct nHotVector
    length ::Int64
    indices ::Set{Int64}
end

function sum(nhvs::Vector{nHotVector})
    if length(nhvs) == 1
        return(nhvs[1])
    else
        two_sum = nHotVector(nhvs[1].length, union(nhvs[1].indices, nhvs[2].indices))
        return(sum(two_sum, nhvs[3:end]...))
    end
end

sum(nhvs::nHotVector...) = sum([nhvs...])

Vector(nhv::nHotVector) = [i in nhv.indices for i in 1:nhv.length]


a = [1, 10, 4, 4, 12, 9]
nhvs_ = collect(nHotVector(20, Set([i])) for i in a)