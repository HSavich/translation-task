function split_string_into_words(string)
    letters_or_ws = replace(string, r"[^\w+]" => " ")
    single_spaced = replace(letters_or_ws, r"\s+" => " ")
    tidy_string= lowercase(single_spaced)
    return(split(tidy_string))
end

function split_file_into_words(filename, text_dir)
    #Naive tokenization scheme
    doc_as_string = open(f->read(f, String), string(text_dir, "/", filename))
    return(split_string_into_words(doc_as_string))
end

function count_words(list_of_words)
    counter = dict()
    for word in list_of_words
        if !in(word, keys(counter)) #new word
            counter[word] = 1
        else                        #seen word
            counter[word] = counter[word] + 1
        end
    end
    return(counter)
end

function construct_vocab_from_counter(counter; count_thresh = 0, freq_thresh = nothing)
    if !(count_thresh == 0 || isnothing(freq_thresh))
        throw(ArgumentError("Cannot have both a count and frequency threshold"))
    elseif !isnothing(freq_thresh)
        num_words = sum([counter[key] for key in keys(counter)])
        count_thresh = ceiling(freq_thresh * num_words)
    end

    vocab = Dict("<unk>" => 1) #<unk> maps to 1

    for word in keys(counter)
        if counter[word] > count_thresh
            vocab[word] = length(vocab) + 1
        end
    end

    return(vocab)
end

