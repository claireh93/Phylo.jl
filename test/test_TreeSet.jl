module TestTreeSet

using Phylo
using DataFrames
using JuliaDB
using Compat.Test

species = ["Dog", "Cat", "Human"]
ntips = 10
df = DataFrame(species = species, count=[10, 20, 3])
observations = ["Dog", "Cat", "Dog", "Dog"]
jdb = table(@NT(species = observations))

@testset "TestSet" begin
    @test length(rand(Ultrametric(ntips), 10)) ==
        length(rand(Nonultrametric(ntips), 10))
    ts = rand(Ultrametric(ntips), 1:10)
    @test ntrees(ts) == 10
    @test length(getbranchnames(ts)) == ntips * 2 - 2
    for name in treenameiter(ts)
        @test name ∈ 1:10
        @test length(getleafnames(ts[name])) == ntips
    end
    for tree in treeiter(ts)
        @test length(getnodenames(tree)) == ntips * 2 - 1
    end
    for tree in ts
        @test length(getbranchnames(tree)) == ntips * 2 - 2
        @test nleaves(tree) == ntips
    end
    @test nleaves(ts) == ntips
    @test getleafnames(TreeSet(Dict{String, NamedTree}(), Dict{String, Any}())) == String[]
    @test getbranchnames(TreeSet(Dict{String, NamedTree}(), Dict{String, Any}())) == Int[]
    @test nleaves(rand(Ultrametric(df), 20)) == length(species)
    @test nleaves(rand(Ultrametric(jdb), 10)) ==
        length(unique(observations))
    @test getleafinfo(rand(Ultrametric(df))) == df
    @test getleafinfo(rand(Ultrametric(jdb), 2)) == jdb
    @test nleaves(rand(Nonultrametric(df), 20)) == length(species)
    @test nleaves(rand(Nonultrametric(jdb), 10)) ==
        length(unique(observations))
    @test getleafinfo(rand(Nonultrametric(df))) == df
    @test getleafinfo(rand(Nonultrametric(jdb), 2)) == jdb
end
end
