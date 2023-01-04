include("Validator.jl")
include("lexer/test_cases.jl")
include("parser/test_cases.jl")

lexer_results  = validate_test.(lexer_tests)
# parser_results = validate_test.(parser_tests)

function display_result(results::Vector{Result}, name::String)::Int
    amount_failed::Int = 0

    printstyled(name * " Results:\n"; color=:normal, underline=true)
    for result in results
        color = result.result ? :cyan : :red
    
        message = result.result ? " [\U2714] " : " [\U2718] "
        message = message * result.test_name * "\n"
    
        printstyled(message; color=color, bold=true)

        if !result.result
            amount_failed += 1
            error_msg = "\t  " * string(result.failed_with) * "\n"
            printstyled("\tFailed with:\n"; color=:red, underline=true)
            printstyled(error_msg; color=:red)
        end
    end
    return amount_failed
end

tests_amt = length(lexer_results)
tests_amt += length(parser_results)
amt_failed = display_result(lexer_results, "Lexer")
# amt_failed += display_result(parser_results, "Parser")

println("\nFinished $(tests_amt) tests -- $(amt_failed)/$(tests_amt) failed.")

# When parser and compiler are finished include them also
# parser_results =
# compiler_results = 
