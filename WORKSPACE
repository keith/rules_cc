workspace(name = "rules_cc")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazel_federation",
    url = "https://github.com/bazelbuild/bazel-federation/archive/a3e140a91ea9ea25b01ad0cc6fbfcaf74f65498f.zip",
    sha256 = "026149d1273a87c634d2270004865fd7474420f88d5bd6ea8d8cd71f4b0f0542",
    strip_prefix = "bazel-federation-a3e140a91ea9ea25b01ad0cc6fbfcaf74f65498f",
    type = "zip",
)

load("@bazel_federation//:repositories.bzl", "rules_cc_deps")
rules_cc_deps()

load("@bazel_federation//setup:rules_cc.bzl", "rules_cc_setup")
rules_cc_setup()

#
# Dependencies for development of rules_cc itself.
#
load("//:internal_deps.bzl", "rules_cc_internal_deps")
rules_cc_internal_deps()

load("//:internal_setup.bzl", "rules_cc_internal_setup")
rules_cc_internal_setup()
