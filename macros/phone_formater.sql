{% macro to_e164(cleaned_digits_column) %}
    case
        -- Handle nulls or blanks immediately
        when {{ cleaned_digits_column }} is null or trim({{ cleaned_digits_column }}) = '' then null
        
        else
            case
                ----------------------------------------------------
                -- 1. SINGAPORE INFERENCE
                ----------------------------------------------------
                -- 8 digits matches standard local SG numbers
                when length({{ cleaned_digits_column }}) = 8 
                    then concat('+65', {{ cleaned_digits_column }})
                
                -- 10 digits starting with 65 is an internationalized SG number missing '+'
                when length({{ cleaned_digits_column }}) = 10 and left({{ cleaned_digits_column }}, 2) = '65'
                    then concat('+', {{ cleaned_digits_column }})

                ----------------------------------------------------
                -- 2. NORTH AMERICA (US/CA) INFERENCE
                ----------------------------------------------------
                -- 10 digits that do NOT start with 65 are standard North American local numbers
                when length({{ cleaned_digits_column }}) = 10 and left({{ cleaned_digits_column }}, 2) != '65'
                    then concat('+1', {{ cleaned_digits_column }})
                
                -- 11 digits starting with 1 is a US number with country code included
                when length({{ cleaned_digits_column }}) = 11 and left({{ cleaned_digits_column }}, 1) = '1'
                    then concat('+', {{ cleaned_digits_column }})


                ----------------------------------------------------
                -- 3. INTERNATIONAL FALLBACK
                ----------------------------------------------------
                when length({{ cleaned_digits_column }}) between 11 and 20
                    then concat('+', {{ cleaned_digits_column }})
                
                else null
            end
    end
{% endmacro %}
