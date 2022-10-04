struct nHotVector
    length ::Int64
    indices ::Set{Int64}
end

nHotVector(l::Int64, i::Int64) = nHotVector(l, Set([i]))

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

"""some values for testing"""
test_indices = [1, 10, 4, 4, 12, 9]
nhvs_ = collect(nHotVector(20, Set([i])) for i in test_indices)

function token_to_ohe(token, vocab)
    if token in keys(vocab)
        return(nHotVector(length(vocab), vocab[token]))
    else
        return(nHotVector(length(vocab), vocab["<unk>"]))
    end
end