use context starter2024
# nova lista onde foi adicionado "!" ao final de cada string. Adicionalmente, a função deve remover todas as strings que possuam menos de 4 caracteres.

fun add_exclamation(initial_list :: List<String>) -> List<String>:
  ask:
    | initial_list == empty then: [list:] 
    | not(initial_list == empty) then: link((initial_list.first) + "!", add_exclamation(initial_list.rest))
  end
end



fun remove_4str_list(str :: List<String>) -> List<String>:
  ask:
    | str == empty then: [list:]
    | string-length(str.first) < 4 then: remove_4str_list(str.rest)
    | string-length(str.first) > 3 then: link(str.first, remove_4str_list(str.rest))
  end
end
  

list_with_exclamation = add_exclamation([list: "abacaxi", "oi", "ovo", "casa", "manuel"])

remove_4str_list(list_with_exclamation)