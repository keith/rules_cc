"""Tests for cc_import."""

load("@bazel_features//:features.bzl", "bazel_features")
load("@rules_testing//lib:analysis_test.bzl", "test_suite")
load("@rules_testing//lib:truth.bzl", "matching")
load("@rules_testing//lib:util.bzl", "util")
load("//cc:cc_import.bzl", "cc_import")
load("//cc:cc_library.bzl", "cc_library")
load("//cc:cc_shared_library.bzl", "cc_shared_library")
load("//tests/cc/testutil:cc_analysis_test.bzl", "cc_analysis_test")

def _test_data_in_runfiles(name, **kwargs):
    util.helper_target(
        cc_import,
        name = name + "/import_with_data",
        hdrs = ["header.h"],
        data = ["data_file.txt"],
    )
    cc_analysis_test(
        name = name,
        impl = _test_data_in_runfiles_impl,
        target = name + "/import_with_data",
        **kwargs
    )

def _test_data_in_runfiles_impl(env, target):
    target = env.expect.that_target(target)
    target.runfiles().contains_predicate(matching.str_endswith("/data_file.txt"))
    target.data_runfiles().contains_predicate(matching.str_endswith("/data_file.txt"))

def _test_shared_library_runfiles_propagation(name, **kwargs):
    util.helper_target(
        cc_library,
        name = name + "/liba",
        srcs = ["liba.cc"],
    )
    util.helper_target(
        cc_shared_library,
        name = name + "/a_shared",
        deps = [name + "/liba"],
    )
    util.helper_target(
        cc_library,
        name = name + "/libb",
        srcs = ["libb.cc"],
    )
    util.helper_target(
        cc_shared_library,
        name = name + "/b_shared",
        deps = [name + "/libb"],
        dynamic_deps = [name + "/a_shared"],
    )

    # Intentionally no deps: liba_shared.so must come via shared_library runfiles propagation.
    util.helper_target(
        cc_import,
        name = name + "/import_b",
        shared_library = name + "/b_shared",
    )
    cc_analysis_test(
        name = name,
        impl = _test_shared_library_runfiles_propagation_impl,
        target = name + "/import_b",
        **kwargs
    )

def _test_shared_library_runfiles_propagation_impl(env, target):
    target = env.expect.that_target(target)
    target.runfiles().contains_predicate(matching.str_endswith("a_shared.so"))

def cc_import_configured_target_tests(name):
    test_suite(
        name = name,
        tests = [
            _test_data_in_runfiles,
            _test_shared_library_runfiles_propagation,
        ] if bazel_features.cc.cc_common_is_in_rules_cc else [],
    )
