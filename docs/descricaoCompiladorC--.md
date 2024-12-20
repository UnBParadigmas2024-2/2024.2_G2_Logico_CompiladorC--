# Descrição do compilador do projeto C--

## Motivação para escolha do projeto

A principal motivação para a escolha deste projeto foi a oportunidade de inovar e explorar um tema pouco abordado na disciplina, já que não identificamos outros grupos que tenham optado por um projeto semelhante.

Além disso, a afinidade de alguns integrantes do grupo com o tema de compiladores foi um fator determinante, pois acreditamos que o interesse contribuiu significativamente para o sucesso do projeto e para o aprendizado coletivo.

## Divisão do grupo

O grupo, composto por 10 integrantes, foi dividido em dois subgrupos de 5 integrantes cada, visando uma melhor organização na execução das tarefas. Um dos subgrupos ficou responsável pela análise léxica, dedicando-se ao desenvolvimento do módulo que identifica e categoriza os tokens do código-fonte. O outro subgrupo concentrou seus esforços na análise sintática, encarregando-se de estruturar as regras gramaticais e construir o parser.

### Grupo léxico

- Heitor Marques
- José Luís Ramos Teixeira
- Lucas Felipe Soares
- Marcos Vinícius de Deus
- Zenilda Pedrosa Vieira

### Grupo sintático

- Bruno Campos Ribeiro
- Bruno Martins Valério Bomfim
- Igor e Silva Penha
- Leonardo Gonçalves Machado
- Raquel T. Eucária Pereira da Costa

## Introdução

O projeto C-- implementa um compilador básico para uma linguagem de programação de escopo reduzido, inspirada na sintaxe do C. Este compilador foi desenvolvido em Prolog e foca principalmente na análise léxica e sintática, cobrindo um subconjunto de construções como declarações, condicionais e operações aritméticas.

O objetivo do projeto é demonstrar a viabilidade de usar Prolog, uma linguagem de programação lógica, como ferramenta para o desenvolvimento de compiladores, explorando suas capacidades de correspondência de padrões e manipulação de estruturas de dados.

Um compilador é uma ferramenta essencial no desenvolvimento de software, permitindo a tradução de linguagens de alto nível para código executável. Este projeto busca apresentar uma abordagem educacional para a criação de compiladores, utilizando a linguagem Prolog para implementar as etapas iniciais do processo: análise léxica e sintática.

A análise léxica identifica as unidades básicas do programa (tokens), como palavras-chave, identificadores e operadores. Já a análise sintática verifica se a sequência de tokens segue as regras gramaticais da linguagem.

A escolha do Prolog foi motivada pela sua natureza declarativa, que simplifica a especificação e a validação de gramáticas. O escopo reduzido da linguagem C-- foi definido para balancear complexidade e viabilidade, devido à limitação de tempo, permitindo a aplicação de conceitos fundamentais de compilação sem a necessidade de um ambiente de execução complexo.

## Definição da gramática
A [gramática](../grammarc--) desenvolvida para o compilador **g-**- é definida pelo conjunto de produções da linguagem e segue o padrão Backus-Naur Form (BNF). Nessa definição:
- `<symbol>` representa uma variável não terminal, sempre delimitada pelo par de símbolos `< >`.
- `::=` indica que o símbolo à esquerda deve ser substituído pela expressão à direita.
- `__expression__` consiste em uma ou mais sequências de símbolos terminais ou não terminais, separadas por uma barra vertical `|` indicando uma escolha, sendo o todo uma possível substituição para o símbolo à esquerda.

Neste escopo, a gramática está livre de recursão à esquerda e paradigma elimina a necessidade de apresentar um conjunto FIRST disjunto. Essas características eliminam a necessidade de ajustes adicionais, como a construção de um tradutor, e permitem a implementação direta de um analisador sintático com base nas regras da gramática.

## Etapas da compilação desenvolvidas

### Análise léxica

O analisador léxico é responsável por identificar e classificar os componentes básicos do código-fonte, como palavras-chave, identificadores, números, operadores e símbolos, convertendo-os em tokens. Esses tokens são então usados pelo analisador sintático para verificar a estrutura do código.

#### Exemplo:

- soma = 10 + 5

1. O identificador soma
2. O símbolo de atribuição =
3. O número 10
4. O símbolo +
5. O número 5

**Implementação**

- Arquivo: `analisador_lexico.pl `.
- No projeto, a análise léxica é realizada pela função `analisa/2`, que recebe como entrada o código-fonte (arquivo) e retorna uma lista de tokens identificados.
- A função percorre a sequência de caracteres do código e, conforme a definição de regras lexicais (presentes no arquivo `base_lexica.pl`), reconhece as palavras-chave, operadores e símbolos, assim como os identificadores e números.
- Os tokens são então agrupados e retornados ao analisador sintático, que irá usá-los para verificar a sequência conforme a gramática definida.

### Análise sintática
O analisador sintático tem como objetivo agrupar várias palavras (tokens) para formar uma sequência que seja validada conforme as regras da sintaxe. Caso a sequência esteja correta, ele gera uma representação em forma de árvore que reflete a estrutura gramatical dos tokens.

**Implementação**

- Arquivo: `analisador_sintatico.pl`. 
- No projeto, foi desenvolvido a primeira etapa: a **verificação dos tokens**.
- Utilizando o conjunto de regras gramaticais definidas para estruturar o código em C-- (`grammarc--`).
- A implementação do analisador foi feita por meio de um parser descendente recursivo, utilizando predicados correspondentes a cada produção da gramática.
- O predicado `parser/1` invoca as regras que correspondem à estrutura do programa.
- A cada verificação, é impresso o "Lookahead" (token atual) e o "Token" esperado, proporcionando visibilidade sobre o que está sendo analisado.
- Se um erro sintático for encontrado, o processo é interrompido e uma mensagem de erro é apresentada.


## Bibliografia

[1] AHO, Alfred V.; LAM, Monica S.; SETHI, Ravi; ULLMAN, Jeffrey D. **Compilers: Principles, Techniques, and Tools**. 2. ed. Boston: Pearson Addison Wesley, 2006.  

[2] FREE SOFTWARE FOUNDATION. GNU Compiler Collection (GCC). Disponível em: [link](https://gcc.gnu.org/onlinedocs/). Acesso em: 11 dez. 2024.

[3] WILDER, Michael. **CS445 - Compiler Design**. University of Idaho. Disponível em: [link](http://www2.cs.uidaho.edu/~mdwilder/cs445/). Acesso em: 4 dez. 2024.

[4] COSTA JÚNIOR, Edson Alves da. **Repositório da Disciplina de Compiladores 1**. Faculdade de Ciências e Tecnologias em Engenharia (FCTE) – Campus Gama, Universidade de Brasília (UnB). Disponível em: [link](https://github.com/edsomjr/Compiladores). Acesso em: 10 dez. 2024.  

[5] RIBAS, Bruno César. **Materiais da Disciplina de Compiladores 1**. Faculdade de Ciências e Tecnologias em Engenharia (FCTE) – Campus Gama, Universidade de Brasília (UnB). Disponível em: [link](https://www.brunoribas.com.br/compiladores/2024-1/). Acesso em: 10 dez. 2024.  

[6] SERRANO, Milene. **Materiais da Disciplina de Paradigmas de Programação**. Faculdade de Ciências e Tecnologias em Engenharia (FCTE) – Campus Gama, Universidade de Brasília (UnB). Disponível em: [link](https://aprender3.unb.br/). Acesso em: 10 dez. 2024.  

[7] SANTIAGO, Judson. **Repositório da Disciplina de Compiladores**. Universidade Federal Rural do Semi-Árido (UFERSA). Disponível em: [link](https://github.com/JudsonSS/Compiladores). Acesso em: 10 dez. 2024.  

[8] WIKIPEDIA. **Backus–Naur Form**. Disponível em: [link](https://en.wikipedia.org/wiki/Backus%E2%80%93Naur_form). Acesso em: 10 dez. 2024.  


## Histórico de versões

| Versão | Data       | Descrição                                                                      |                                                 Autor                                                 |
| :----: | ---------- | ------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------: |
| `1.0`  | 10/12/2024 | Criação do documento e adição da introdução                                          | [Marcos Vinícius](https://github.com/Marcos574)  |
| `1.1`  | 11/12/2024 | Adição da gramática e do sintático                                          | [Raquel Eucaria](https://github.com/raqueleucaria)  |
| `1.2`  | 12/12/2024 | Adição do léxico                                | [Raquel Eucaria](https://github.com/raqueleucaria)  |

