use context starter2024


#formas geometricas
circle(50,"solid","yellow")
rectangle(50,50,"outline", "black")







#função que gera bandeiras
fun bandeira(cor1, cor2, cor3):
  beside(
    beside(
      rectangle(30, 60, "solid", cor1),
      rectangle(30, 60, "solid", cor2)),
    rectangle(30, 60, "solid", cor3))
end

#exemplo
bandeira("red", "white", "blue")







#funçao de calculo

fun tico_e_teco(x, y):
  900 + x + ( -1 * (y * y))
end







#função que gera bandeiras com estrelas
#eu que fiz e nao funciona
fun bandeira_estrelada(cor1, cor2, cor3, cor_estrela):
  beside(
    beside(
      beside(
        rectangle(30, 60, "solid", cor1),
        star(15, "solid", cor_estrela)),
      rectangle(30, 60, "solid", cor2)), 
    rectangle(30, 60, "solid", cor3))

end





# nova versão com a estrela centralizada mas na esquerda
fun bandeira_estrelada_centralizada(cor1, cor2, cor3, cor_estrela):
  overlay(
    star(15, "solid", cor_estrela),
    beside(
      beside(
        rectangle(30, 60, "solid", cor1),
        rectangle(30, 60, "solid", cor2)),
      rectangle(30, 60, "solid", cor3)))
end

# exemplo
bandeira_estrelada_centralizada("red", "white", "blue", "yellow")











#versao final

fun bandeira_estrelada_centralizada_xy(cor1, cor2, cor3, cor_estrela):
  bandeira_base = beside(
    beside(
      rectangle(30, 60, "solid", cor1),
      rectangle(30, 60, "solid", cor2)),
    rectangle(30, 60, "solid", cor3))

  overlay-align("center", "center", star(15, "solid", cor_estrela), bandeira_base)
end














#| como eu tinha feito
fun carrinho(paes, bolos, doces):
  valor = (2 * paes) + (3 * bolos) + (4 * doces)
  text(valor, 24, "gray")
  circle(50, "outline", "blue")
  overlay-align("center", "center", text(valor, 24, "gray"), circle(50, "outline", "blue"))
end
|#


# nova solução para mostrar o valor dentro do círculo
fun carrinho_ia(paes, bolos, doces):
  valor = (2 * paes) + (3 * bolos) + (4 * doces)
  valor_texto = num-to-string(valor)
  overlay-align(
    "center",
    "center",
    text(valor_texto, 24, "gray"),
    circle(50, "solid", "blue"))
end

# exemplo
carrinho_ia(2, 1, 3)










fun area-anel(r-ext :: Number, r-int :: Number) -> Number:






