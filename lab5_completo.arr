use context starter2024
#|
    Este arquivo contém o template para a solução dos exercícios do Laboratório 5 de INF05008 - Pensamento Computacional.

    Autor: Prof. Lucas N. Alegre
|#

include image
# Importa as estruturas, funções e constantes da biblioteca de chat (a mesma do Laboratório 4)
include url("https://lucasalegre.github.io/pensamento-computacional/src/data/labs/chat-lib4.arr")

# ATENÇÃO: A estrutura Usuario e as constantes CONTATO-ANA e CONTATO-EU já estão definidas na biblioteca. Não as redefina neste arquivo!


#|
    Definições de Dados (fornecidas prontas)
|#

data Agenda:
  # Uma agenda de contatos é uma árvore binária de pesquisa (ABP), ordenada pelo nome dos contatos:
  | vazia
  | no(
      contato :: Usuario,  # Contato guardado neste nó
      esq :: Agenda,       # Contatos cujos nomes vêm ANTES de contato.nome (em ordem alfabética)
      dir :: Agenda)       # Contatos cujos nomes vêm DEPOIS de contato.nome (em ordem alfabética)
end

type ListaDeRespostas = List<Comentario>
# Uma ListaDeRespostas é:
# | empty
# | link(first :: Comentario, rest :: ListaDeRespostas)

data Comentario:
  # Um comentário em um tópico de discussão, junto com as respostas que recebeu:
  | comentario(
      autor :: String,                # Nome de quem escreveu o comentário
      texto :: String,                # Texto do comentário
      curtidas :: Number,             # Quantidade de curtidas que o comentário recebeu
      respostas :: ListaDeRespostas)  # Respostas a este comentário (cada resposta também é um Comentario)
end


#|
    Constantes (fornecidas prontas)
|#

fun cria-contato(nome :: String, online :: Boolean) -> Usuario:
  doc: "Dado um nome e um status (true se online), cria um contato com o avatar gerado a partir da inicial do nome."
  usuario(nome, avatar-contato(nome), online)
end

# Contatos de teste (CONTATO-ANA, que está online, já vem da biblioteca)
CONTATO-BIA = cria-contato("Bia", false)
CONTATO-CAIO = cria-contato("Caio", true)
CONTATO-DUDA = cria-contato("Duda", false)

# Contatos da turma, usados para construir uma agenda maior no Exercício 3.
# A ordem da lista foi escolhida para que a agenda construída fique balanceada.
CONTATOS-TURMA = [list:
  cria-contato("Tiago", true),
  cria-contato("Rafa", false),
  cria-contato("Otto", true),
  cria-contato("Marina", true),
  cria-contato("Iris", false),
  cria-contato("Gabi", true),
  CONTATO-CAIO,
  CONTATO-ANA,
  cria-contato("Sofia", false),
  cria-contato("Nico", true),
  cria-contato("Heitor", true),
  CONTATO-BIA,
  cria-contato("Pedro", false),
  CONTATO-DUDA,
  cria-contato("Leo", true)]

# Tópico maior, com 9 comentários em 4 níveis:
TOPICO-DUVIDA =
  comentario("Gabi", "Pessoal, qual a diferença entre AB e ABP?", 5, [list:
    comentario("Heitor", "Na ABP, os menores ficam à esquerda e os maiores à direita.", 8, [list:
      comentario("Gabi", "Ahh, é por isso que a busca é mais rápida?", 2, [list:
        comentario("Heitor", "Isso! A cada passo você desce por um lado só.", 4, empty),
        comentario("Iris", "Desde que a árvore não fique toda torta, né?", 3, empty)]),
      comentario("Leo", "Tipo uma lista telefônica!", 1, empty)]),
    comentario("Marina", "Tem um exemplo nos slides da aula 21.", 2, [list:
      comentario("Gabi", "Valeu, Marina!", 0, empty)]),
    comentario("Nico", "Também queria saber...", 0, empty)])


#|
    Funções auxiliares de desenho (prontas)
    Você não precisa alterar estas funções: elas servem para visualizar as agendas.
|#

fun desenha-no-agenda(u :: Usuario) -> Image:
  doc: "Desenha um nó da agenda: o avatar do contato, com o indicador de online/offline, e o nome logo abaixo."
  above(desenha-avatar(u), text(u.nome, 12, "black"))
end

fun desenha-agenda(a :: Agenda) -> Image:
  doc: "Desenha a agenda em forma de árvore: cada contato aparece acima das suas subárvores esquerda e direita, lado a lado."
  cases (Agenda) a:
    # Agenda vazia: desenha um marcador cinza
    | vazia => text("vazia", 10, "lightgray")
    # Agenda não vazia: o desenho depende de o nó ter filhos ou não
    | no(c, esq, dir) =>
      if is-vazia(esq) and is-vazia(dir):
        # Nó sem filhos (folha): desenha apenas o contato
        desenha-no-agenda(c)
      else:
        # Nó com filhos: desenha o contato acima das subárvores esquerda e direita, lado a lado
        desenho-esq = desenha-agenda(esq)
        desenho-dir = desenha-agenda(dir)
        filhos = beside-align("top", desenho-esq, beside(espaco(16, "transparent"), desenho-dir))
        # Linhas pretas ligando o contato (no meio do desenho) ao meio do desenho de cada subárvore
        largura = image-width(filhos)
        meio-esq = image-width(desenho-esq) / 2
        meio-dir = image-width(desenho-esq) + 16 + (image-width(desenho-dir) / 2)
        fundo = rectangle(largura, 20, "solid", "transparent")
        linhas = add-line(add-line(fundo, largura / 2, 0, meio-esq, 20, "black"), largura / 2, 0, meio-dir, 20, "black")
        above(desenha-no-agenda(c), above(linhas, filhos))
      end
  end
end


#|
    Parte 1: Agenda de Contatos (Árvore Binária de Pesquisa)
|#


#|
    Exercício 1: Agenda de teste
|#

# Defina a constante AGENDA-TESTE com a agenda abaixo, usando os contatos de teste
# CONTATO-ANA, CONTATO-BIA, CONTATO-CAIO e CONTATO-DUDA:
#
#              Caio
#             /    \
#          Ana      Duda
#             \
#             Bia
#
AGENDA-TESTE = no(CONTATO-CAIO, no(CONTATO-ANA, vazia, no(CONTATO-BIA, vazia, vazia)), no(CONTATO-DUDA, vazia, vazia))

# Confira o desenho da sua agenda:
desenha-agenda(AGENDA-TESTE)


#|
    Exercício 2: Buscando um contato
|#

fun busca-status(nome :: String, a :: Agenda) -> String:
  doc: "Dado o nome de um contato e uma agenda, devolve 'online' ou 'offline', conforme o status do contato com este nome na agenda. Se não houver contato com este nome, devolve 'Contato não encontrado'."
  cases (Agenda) a:
    | vazia => "Contato não encontrado"
    | no(c, esq, dir) =>
      if nome < c.nome:
        busca-status(nome, esq)
      else if nome > c.nome:
        busca-status(nome, dir)
      else:
        if c.online:
          "online"
        else:
          "offline"
        end
      end
  end
where:
  busca-status("Caio", AGENDA-TESTE) is "online"
  busca-status("Eva", AGENDA-TESTE) is "Contato não encontrado"
end


#|
    Exercício 3: Adicionando contatos
|#

fun insere-contato(u :: Usuario, a :: Agenda) -> Agenda:
  doc: "Dado um contato e uma agenda, devolve uma nova agenda com o contato inserido na posição correta, mantendo a ordem alfabética. Se já houver um contato com o mesmo nome, ele é substituído pelo novo."
  cases (Agenda) a:
    | vazia => no(u, vazia, vazia)
    | no(c, esq, dir) =>
      if u.nome < c.nome:
        no(c, insere-contato(u, esq), dir)
      else if u.nome > c.nome:
        no(c, esq, insere-contato(u, dir))
      else:
        no(u, esq, dir)
      end
  end
where:
  insere-contato(CONTATO-ANA, vazia) is no(CONTATO-ANA, vazia, vazia)
  # Eva vem depois de Caio e de Duda: vai para a direita de Duda
  insere-contato(cria-contato("Eva", true), AGENDA-TESTE) is
    no(CONTATO-CAIO,
      no(CONTATO-ANA, vazia, no(CONTATO-BIA, vazia, vazia)),
      no(CONTATO-DUDA, vazia, no(cria-contato("Eva", true), vazia, vazia)))
end

# Função auxiliar pronta, que usa insere-contato (como a função constroi-abp da aula)
fun cria-agenda(contatos :: List<Usuario>) -> Agenda:
  doc: "Dada uma lista de contatos, constrói uma agenda com todos eles, inserindo o primeiro contato na agenda construída com o resto da lista."
  cases (List<Usuario>) contatos:
    # Lista vazia: a agenda é vazia
    | empty => vazia
    # Lista não vazia: insere o primeiro contato na agenda construída com o resto da lista
    | link(f, r) => insere-contato(f, cria-agenda(r))
  end
where:
  cria-agenda(empty) is vazia
  # O último da lista (Caio) é inserido primeiro e vira a raiz; depois vêm Ana, Bia e Duda
  cria-agenda([list: CONTATO-DUDA, CONTATO-BIA, CONTATO-ANA, CONTATO-CAIO]) is AGENDA-TESTE
end

# Agenda com os 15 contatos da turma
AGENDA-TURMA = cria-agenda(CONTATOS-TURMA)

# Descomente as linhas abaixo para visualizar a agenda da turma e buscar um contato nela:
desenha-agenda(AGENDA-TURMA)
busca-status("Iris", AGENDA-TURMA)


#|
    Parte 2: Tópicos de Discussão (Árvore N-ária e Recursão Mútua)
|#


#|
    Exercício 4: Tópico de teste
|#

# Defina as constantes abaixo para representar o tópico:
#
#   Bia: "Alguém já começou o Lab 5?" (2 curtidas)
#   ├── Ana: "Já! A parte da ABP foi tranquila." (3 curtidas)
#   │   └── Duda: "Eu também!" (1 curtida)
#   └── Caio: "Ainda não, começo hoje." (0 curtidas)
#
# A resposta da Duda já está pronta, como exemplo:
RESP-DUDA = comentario("Duda", "Eu também!", 1, empty)
RESP-ANA = comentario("Ana", "Já! A parte da ABP foi tranquila.", 3, [list: RESP-DUDA])
RESP-CAIO = comentario("Caio", "Ainda não, começo hoje.", 0, empty)
TOPICO-TESTE = comentario("Bia", "Alguém já começou o Lab 5?", 2, [list: RESP-ANA, RESP-CAIO])


#|
    Exercício 5: Contando comentários
|#

fun conta-comentarios(c :: Comentario) -> Number:
  doc: "Dado um comentário, devolve o número total de comentários na conversa: o próprio comentário e todas as respostas, em qualquer nível."
  1 + conta-comentarios-lista(c.respostas)
where:
  conta-comentarios(RESP-DUDA) is 1
  conta-comentarios(TOPICO-TESTE) is 4
end

fun conta-comentarios-lista(lr :: ListaDeRespostas) -> Number:
  doc: "Dada uma lista de respostas, devolve o número total de comentários nas respostas e nas respostas delas, em qualquer nível."
  cases (ListaDeRespostas) lr:
    | empty => 0
    | link(f, r) => conta-comentarios(f) + conta-comentarios-lista(r)
  end
where:
  conta-comentarios-lista(empty) is 0
  conta-comentarios-lista(TOPICO-TESTE.respostas) is 3
end


#|
    Exercício 6: Desenhando um tópico
|#

# Funções auxiliares prontas, para usar em desenha-topico e desenha-respostas:

fun desenha-comentario(c :: Comentario) -> Image:
  doc: "Desenha um único comentário, sem as respostas: um balão com o autor, o texto e o número de curtidas."
  conteudo = above-align("left",
    text(c.autor, 11, "darkgreen"),
    above-align("left",
      text(c.texto, 13, "black"),
      text("♥ " + num-to-string(c.curtidas), 10, "crimson")))

  # Balão com uma pequena margem abaixo, para separá-lo do próximo comentário
  above-align("left", desenha-balao(conteudo, "white"), rectangle(1, 6, "solid", "white"))
end

fun recua(img :: Image) -> Image:
  doc: "Desloca uma imagem para a direita, com uma linha vertical cinza à esquerda, para mostrar que ela está dentro de uma conversa (são respostas)."
  if image-height(img) == 0:
    # Imagem vazia (não há respostas): não há nada para deslocar
    img
  else:
    # Imagem com conteúdo: coloca um espaço e uma linha vertical à esquerda da imagem
    linha = rectangle(2, image-height(img), "solid", "lightgray")
    beside-align("top", espaco(24, "white"), beside-align("top", linha, beside-align("top", espaco(8, "white"), img)))
  end
end

# Complete as funções abaixo:

fun desenha-topico(c :: Comentario) -> Image:
  doc: "Dado um comentário, desenha a conversa: o comentário e, abaixo dele e recuadas para a direita, as suas respostas."
  above-align("left", desenha-comentario(c), recua(desenha-respostas(c.respostas)))
end

fun desenha-respostas(lr :: ListaDeRespostas) -> Image:
  doc: "Dada uma lista de respostas, desenha a conversa de cada resposta, uma abaixo da outra, alinhadas à esquerda."
  cases (ListaDeRespostas) lr:
    | empty => empty-image
    | link(f, r) => above-align("left", desenha-topico(f), desenha-respostas(r))
  end
end

# Descomente as linhas abaixo para visualizar os tópicos:
desenha-topico(TOPICO-TESTE)
desenha-topico(TOPICO-DUVIDA)