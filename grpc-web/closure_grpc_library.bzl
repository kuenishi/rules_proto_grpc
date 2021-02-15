"""Generated definition of closure_grpc_library."""

load("//grpc-web:closure_grpc_compile.bzl", "closure_grpc_compile")
load("//internal:compile.bzl", "proto_compile_attrs")
load("//closure:closure_proto_compile.bzl", "closure_proto_compile")
load("@io_bazel_rules_closure//closure:defs.bzl", "closure_js_library")

def closure_grpc_library(**kwargs):  # buildifier: disable=function-docstring
    # Compile protos
    name_pb = kwargs.get("name") + "_pb"
    name_pb_grpc = kwargs.get("name") + "_pb_grpc"
    closure_proto_compile(
        name = name_pb,
        **{
            k: v for (k, v) in kwargs.items()
            if k in ["protos" if "protos" in kwargs else "deps"] + proto_compile_attrs.keys()
        }  # Forward args
    )

    closure_grpc_compile(
        name = name_pb_grpc,
        **{
            k: v for (k, v) in kwargs.items()
            if k in ["protos" if "protos" in kwargs else "deps"] + proto_compile_attrs.keys()
        }  # Forward args
    )

    # Create closure library
    closure_js_library(
        name = kwargs.get("name"),
        srcs = [name_pb, name_pb_grpc],
        deps = GRPC_DEPS + (kwargs.get("deps", []) if "protos" in kwargs else []),
        suppress = [
            "JSC_LATE_PROVIDE_ERROR",
            "JSC_UNDEFINED_VARIABLE",
            "JSC_IMPLICITLY_NULLABLE_JSDOC",
            "JSC_STRICT_INEXISTENT_PROPERTY",
            "JSC_POSSIBLE_INEXISTENT_PROPERTY",
            "JSC_UNRECOGNIZED_TYPE_ERROR",
            "JSC_UNUSED_PRIVATE_PROPERTY",
            "JSC_EXTRA_REQUIRE_WARNING",
            "JSC_INVALID_INTERFACE_MEMBER_DECLARATION",
            "JSC_TYPE_MISMATCH",
            "CR_NOT_PROVIDED",
        ],
        visibility = kwargs.get("visibility"),
        tags = kwargs.get("tags"),
    )

GRPC_DEPS = [
    "@com_github_grpc_grpc_web//javascript/net/grpc/web:abstractclientbase",
    "@com_github_grpc_grpc_web//javascript/net/grpc/web:clientreadablestream",
    "@com_github_grpc_grpc_web//javascript/net/grpc/web:grpcwebclientbase",
    "@com_github_grpc_grpc_web//javascript/net/grpc/web:error",
    "@io_bazel_rules_closure//closure/library",
    "@io_bazel_rules_closure//closure/protobuf:jspb",
]
