# ♟️ Xadrez em Portugol — V4.1

> Um jogo de xadrez completo desenvolvido em **Portugol** para dois jogadores no mesmo computador, criado como ferramenta pedagógica para o ensino de **lógica de programação** e **pensamento computacional**.

---

## 📋 Sobre o Projeto

O **Xadrez em Portugol** foi desenvolvido por **Allan Rasec de Araujo Brito** e **Thiago Oliveira da Silva** como parte de um projeto acadêmico do **Instituto Federal do Pará (IFPA) — Campus Castanhal**, no curso de **Engenharia de Alimentos**, para a disciplina de **Algoritmo e Lógica de Programação**, sob orientação do professor **José Alcimar**.

O projeto busca demonstrar que a lógica de programação pode ser ensinada de maneira **lúdica e prática**, aproximando conceitos computacionais de estudantes de áreas não necessariamente relacionadas à tecnologia.

Para isso, foi desenvolvido um jogo de xadrez funcional utilizando **Portugol Studio**, permitindo trabalhar conceitos como:

* Lógica de programação;
* Estruturas condicionais;
* Estruturas de repetição;
* Funções;
* Matrizes;
* Manipulação de eventos;
* Controle de estados;
* Validação de regras;
* Interação com o usuário;
* Organização e decomposição de problemas.

---

## ✨ Funcionalidades

### ♟️ Tabuleiro e interface

* Tabuleiro de **8×8 casas**;
* Casas alternadas visualmente;
* Representação gráfica das peças;
* Identificação das peças por letras:

  * `T` — Torre
  * `C` — Cavalo
  * `B` — Bispo
  * `Q` — Dama
  * `K` — Rei
  * `P` — Peão
* Interface gráfica responsiva;
* Modo **tela cheia**.

### 🖱️ Interação

* Sistema de **arrastar e soltar (Drag and Drop)**;
* Controle das peças utilizando o mouse;
* Seleção e movimentação das peças;
* Indicação visual das casas disponíveis.

### ⚔️ Regras e lógica

* Validação dos movimentos das peças;
* Controle de turnos;
* Detecção de **Xeque**;
* Detecção de **Xeque-Mate**;
* Controle da posição das peças através de matrizes;
* Histórico das jogadas.

### 🔄 Recursos da partida

* **Voltar Jogada**;
* Histórico de até **50 lances**;
* Sistema de **Trilhas**, indicando movimentos válidos;
* Proposta de **Empate**;
* Sistema de **Desistência**;
* Confirmação de ações;
* Temporizador de **10 segundos**;
* Efeitos sonoros durante os movimentos.

---

## 🛠️ Tecnologias Utilizadas

O projeto foi desenvolvido utilizando o **Portugol Studio** e suas bibliotecas:

| Biblioteca | Utilização                                                 |
| ---------- | ---------------------------------------------------------- |
| `Graficos` | Renderização do tabuleiro, peças, interface e modo gráfico |
| `Mouse`    | Captura de cliques, coordenadas e interação com as peças   |
| `Util`     | Controle de tempo, temporizadores e pausas                 |
| `Sons`     | Reprodução do áudio dos movimentos                         |

### Linguagem

**Portugol**

### Ambiente

**Portugol Studio**

---

## 📂 Estrutura do Projeto

```text
xadrez-portugol/
│
├── src/
│   ├── Codigo_Institucional.por
│   └── Codigo_Limpo.por
│
├── audio/
│   └── Movimento.mp3
│
├── docs/
│   ├── Relatorio_Completo.pdf
│   └── Relatorio_Completo.html
│
└── README.md
```

### 📘 Versões do código

#### `Codigo_Institucional.por`

Versão **comentada e documentada**, desenvolvida para facilitar a compreensão do código por professores e estudantes.

#### `Codigo_Limpo.por`

Versão **sem os comentários explicativos**, permitindo que os alunos explorem e analisem a lógica do programa de maneira mais independente.

---

## 🚀 Como Executar

### 1. Instale o Portugol Studio

Baixe o **Portugol Studio** através do site oficial:

https://portugol.dev/

### 2. Clone este repositório

```bash
git clone https://github.com/Dinneiro/xadrez-portugol.git
```

Entre na pasta:

```bash
cd xadrez-portugol
```

### 3. Abra o projeto

No Portugol Studio, abra um dos arquivos:

```text
src/Codigo_Institucional.por
```

ou

```text
src/Codigo_Limpo.por
```

### 4. Execute

Clique em **Executar** ou pressione:

```text
F5
```

O jogo será iniciado e poderá ser jogado por dois jogadores no mesmo computador.

---

## 📚 Metodologia de Ensino — "Jogada a Jogada"

O projeto também apresenta uma proposta pedagógica chamada **"Jogada a Jogada"**, estruturada em sete etapas progressivas.

### 1. 🎮 Jogar

O estudante começa experimentando o programa já funcional.

### 2. 👀 Observar

Identificação dos comportamentos, elementos visuais e interações presentes no jogo.

### 3. 🧩 Decompor

Relacionamento dos comportamentos observados com as funções e estruturas lógicas utilizadas no código.

### 4. 🏗️ Construir

Reprodução de telas, estruturas e funcionalidades básicas em duplas.

### 5. 🐛 Testar e Depurar

Investigação de erros e problemas encontrados durante a execução do programa.

### 6. 🔀 Remixar

Criação de novas soluções e modificações a partir do código existente.

### 7. 💡 Compartilhar e Refletir

Apresentação das soluções desenvolvidas e reflexão sobre os conceitos de programação utilizados.

---

## 📖 Documentação

O projeto possui um relatório técnico completo contendo informações sobre:

* Metodologia de ensino;
* Desenvolvimento do jogo;
* Decomposição das funcionalidades;
* Estrutura lógica do programa;
* Plano de testes;
* Decisões de projeto;
* Organização do código;
* Aplicação pedagógica.

📄 **[Acessar o relatório completo](docs/Relatorio_Completo.pdf)**

---

## ⚠️ Limitações

Apesar de implementar diversas regras e recursos do xadrez, o projeto possui algumas limitações:

* Não possui sistema de **roque**;
* Não possui movimento **en passant**;
* Não possui adversário controlado por inteligência artificial;
* A promoção do peão ocorre automaticamente para **Dama**.

---

## 🎓 Contexto Acadêmico

**Instituição:** Instituto Federal do Pará — IFPA
**Campus:** Castanhal
**Curso:** Engenharia de Alimentos
**Disciplina:** Algoritmo e Lógica de Programação
**Professor:** José Alcimar
**Versão:** 4.1

---

## 👥 Autores

### Allan Rasec de Araujo Brito

📧 **E-mail:**
`allanrasec2018@gmail.com`

### Thiago Oliveira da Silva

💻 **GitHub:** [@Dinneiro](https://github.com/Dinneiro)

🔗 **LinkedIn:** [Thiago Oliveira](https://linkedin.com/in/thiago-oliveira-8a2724356)

📧 **E-mail:**
`thiagosilvafx5@gmail.com`

---

## 📌 Objetivo do Projeto

> **Transformar conceitos de lógica de programação em uma experiência prática, visual e interativa.**

O xadrez funciona como uma ferramenta para demonstrar como problemas complexos podem ser divididos em pequenas regras e transformados em estruturas computacionais.

Cada movimento realizado no tabuleiro representa uma oportunidade para trabalhar conceitos fundamentais de programação, tornando o aprendizado mais **visual, prático e significativo**.

---

## ⭐ Projeto Acadêmico

Desenvolvido como projeto acadêmico no:

**Instituto Federal do Pará — Campus Castanhal**

**Engenharia de Alimentos · Algoritmo e Lógica de Programação · V4.1**

---

<p align="center">
  ♟️ <strong>Xadrez em Portugol</strong><br>
  Lógica de programação através da prática.
</p>
