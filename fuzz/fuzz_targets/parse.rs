#![no_main]
use libfuzzer_sys::fuzz_target;
use php_parser_rs::parser;

fuzz_target!(|data: &[u8]| {
    let _ = parser::parse(data);
});