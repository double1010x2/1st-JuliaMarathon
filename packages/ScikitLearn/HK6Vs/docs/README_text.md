# ScikitLearn.jl

[![Documentation Status](https://readthedocs.org/projects/scikitlearnjl/badge/?version=latest)](http://scikitlearnjl.readthedocs.org/en/latest/?badge=latest)

ScikitLearn.jl implements the popular
[scikit-learn](http://scikit-learn.org/stable/) interface and algorithms in
Julia. It supports both models from the Julia ecosystem and those of the
[scikit-learn library](http://scikit-learn.org/stable/modules/classes.html)
(via PyCall.jl).

**Disclaimer**: ScikitLearn.jl borrows code and documentation from
[scikit-learn](http://scikit-learn.org/stable/), but *it is not an official part
of that project*. It is licensed under [BSD-3](LICENSE).

Main features:

- Around 150 [Julia](http://scikitlearnjl.readthedocs.io/en/latest/models/#julia-models) and [Python](http://scikitlearnjl.readthedocs.io/en/latest/models/#python-models) models accessed through a uniform [interface](http://scikitlearnjl.readthedocs.org/en/latest/api/)
- [Pipelines and FeatureUnions](http://scikitlearnjl.readthedocs.org/en/latest/pipelines/)
- [Cross-validation](http://scikitlearnjl.readthedocs.org/en/latest/cross_validation/)
- [Hyperparameter tuning](http://scikitlearnjl.readthedocs.org/en/latest/model_selection/)
- [DataFrames support](http://scikitlearnjl.readthedocs.org/en/latest/dataframes/)

Check out the [Quick-Start
Guide](http://scikitlearnjl.readthedocs.org/en/latest/quickstart/) for a
tour.

## Installation

To install ScikitLearn.jl, run `Pkg.add("ScikitLearn")` at the REPL.

To import Python models (optional), ScikitLearn.jl requires [the scikit-learn Python library](http://scikitlearnjl.readthedocs.io/en/latest/models/#installation), which will be installed automatically when needed. Most of the examples use [PyPlot.jl](https://github.com/stevengj/PyPlot.jl)

## Documentation

See the [manual](http://scikitlearnjl.readthedocs.org/en/latest/) and
[example gallery](docs/examples.md).

## Support

The primary venues for getting support on ScikitLearn.jl are [Discourse](https://discourse.julialang.org) and [Github issues](https://github.com/cstjean/ScikitLearn.jl/issues).