include("nHotVectors.jl")
include("tokenizers.jl")

const DIR_OF_TXTS = "data/state_union_raw"

dir_files = readdir(DIR_OF_TXTS)
txt_files = [f for f in dir_files if occursin(".txt", f)]

#construct vocab
vocab = Dict()

for txt_file in txt_files
    tokens = word_tokenize(txt_file, DIR_OF_TXTS)
    for token in tokens
        if !in(token, keys(vocab))
            vocab[token] = (length(vocab) + 1, 1)
        else
            a, b = vocab[token]
            vocab[token] = (a, b+1)
        end
    end
    print(string("\ndid ", txt_file, "\n"))
    print(length(vocab))
end

println("\nLength of unpruned vocab: ", length(vocab))
top_vocab = Dict()
for key in keys(vocab)
    if vocab[key][2] > 20
        top_vocab[key] = length(top_vocab) + 1
    end
end
top_vocab["<unk>"] = length(top_vocab) + 1
print("Length of pruned vocab: ", length(top_vocab))

function context_idxs(idx, context_size, num_tokens)

    first_idx = idx - context_size
    if idx - context_size < 1
        first_idx = num_tokens
    end

    last_idx = idx + context_size
    if idx + context_size > num_tokens
        last_idx = num_tokens
    end
    return(first_idx:idx-1,idx+1:last_idx)
end