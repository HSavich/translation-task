using Flux: onehot

adams_string = open(f->read(f, String), "data/state_union_raw/Adams_1797.txt")#::Vector{SubString}

function string_to_tokens(file_as_string)
    file_as_string = replace(file_as_string, r"[^\w+]" => " ")
    file_as_string = replace(file_as_string, r"\s+" => " ")
    file_as_string = lowercase(file_as_string)
    return(eachsplit(file_as_string))
end

adams_tokenized = string_to_tokens(adams_string)
vocab_words = unique(adams_tokenized)

vocab = Dict()
for (i, w) in enumerate(vocab_words)
    vocab[w] = i
end

L = length(vocab)
ohe = [onehot(vocab[token], L) for token in adams_tokenized]

"""
c is context size, number of tokens considered on either side
"""

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


