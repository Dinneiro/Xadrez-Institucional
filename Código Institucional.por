programa
{
	// Inclusão das bibliotecas padrão do Portugol Studio
	inclua biblioteca Graficos --> g
	inclua biblioteca Mouse --> m
	inclua biblioteca Util --> u
	inclua biblioteca Sons --> s

	// Matrizes principais do tabuleiro
	inteiro dono[8][8]  // 0 = vazio, 1 = Jogador 1 (Brancas), 2 = Jogador 2 (Pretas)
	cadeia peca[8][8]  // "P" = Peão, "T" = Torre, "C" = Cavalo, "B" = Bispo, "Q" = Dama, "K" = Rei

	// Variáveis de controle para o histórico de jogadas (funcionalidade "Voltar")
	inteiro historico_dono[50][64]
	cadeia historico_peca[50][64]
	inteiro historico_turno[50]
	inteiro quantidade_historico = 0

	// Variáveis de controle geral da partida
	inteiro som_movimento = -1
	inteiro turno = 1

	logico encerrado = falso
	logico selecionada = falso
	logico arrastando = falso
	logico trilhas = falso
	logico tela_cheia = falso

	// Coordenadas e posições auxiliares
	inteiro sel_linha = -1
	inteiro sel_coluna = -1
	inteiro origem_linha = -1
	inteiro origem_coluna = -1
	inteiro mouse_x = 0
	inteiro mouse_y = 0

	// Estados de xeque e xeque-mate
	logico jogador1_em_xeque = falso
	logico jogador2_em_xeque = falso
	logico jogador1_mate = falso
	logico jogador2_mate = falso

	// Controles para empate e desistência
	inteiro proposta_empate = 0
	inteiro solicitacao_desistencia = 0
	inteiro tempo_inicio_desistencia = 0

	cadeia mensagem = ""

	// Configurações de layout e tamanho da tela
	inteiro tamanho_casa = 70
	inteiro margem_x = 30
	inteiro margem_y = 25
	inteiro botao_y = 600

	// Função principal executada ao iniciar o programa
	funcao inicio()
	{
		// Carrega o arquivo de som do movimento
		som_movimento = s.carregar_som("Movimento.mp3")
		
		g.iniciar_modo_grafico(verdadeiro)
		g.definir_dimensoes_janela(620, 760)
		g.definir_titulo_janela("Xadrez V4.1 - Círculos e Letras")

		inicializar_tabuleiro()
		atualizar_estado_jogo()
		atualizar_layout()

		// Loop principal do jogo
		enquanto (verdadeiro)
		{
			processar_tempo_desistencia()
			processar_mouse()
			atualizar_layout()
			desenhar_tudo()
			u.aguarde(15)
		}
	}

	// Posiciona todas as peças nas posições iniciais do xadrez
	funcao inicializar_tabuleiro()
	{
		inteiro l, c

		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				dono[l][c] = 0
				peca[l][c] = " "
			}
		}

		// Peças pretas (Linhas 0 e 1)
		dono[0][0] = 2 peca[0][0] = "T"
		dono[0][1] = 2 peca[0][1] = "C"
		dono[0][2] = 2 peca[0][2] = "B"
		dono[0][3] = 2 peca[0][3] = "Q"
		dono[0][4] = 2 peca[0][4] = "K"
		dono[0][5] = 2 peca[0][5] = "B"
		dono[0][6] = 2 peca[0][6] = "C"
		dono[0][7] = 2 peca[0][7] = "T"

		para (c = 0; c < 8; c++)
		{
			dono[1][c] = 2
			peca[1][c] = "P"
		}

		// Peças brancas (Linhas 6 e 7)
		dono[7][0] = 1 peca[7][0] = "T"
		dono[7][1] = 1 peca[7][1] = "C"
		dono[7][2] = 1 peca[7][2] = "B"
		dono[7][3] = 1 peca[7][3] = "Q"
		dono[7][4] = 1 peca[7][4] = "K"
		dono[7][5] = 1 peca[7][5] = "B"
		dono[7][6] = 1 peca[7][6] = "C"
		dono[7][7] = 1 peca[7][7] = "T"

		para (c = 0; c < 8; c++)
		{
			dono[6][c] = 1
			peca[6][c] = "P"
		}

		mensagem = "Jogo iniciado. Vez do Jogador 1 (Brancas)."
	}

	// Calcula o tamanho das casas proporcionalmente à janela
	funcao atualizar_layout()
	{
		inteiro largura, altura, espaco_y, novo_tamanho

		largura = g.largura_janela()
		altura = g.altura_janela()

		espaco_y = altura - 180
		novo_tamanho = espaco_y / 8

		se ((novo_tamanho * 8) > largura - 40)
		{
			novo_tamanho = (largura - 40) / 8
		}

		se (novo_tamanho < 40) { novo_tamanho = 40 }

		tamanho_casa = novo_tamanho
		margem_x = (largura - (8 * tamanho_casa)) / 2
		se (margem_x < 10) { margem_x = 10 }

		margem_y = (espaco_y - (8 * tamanho_casa)) / 2
		se (margem_y < 10) { margem_y = 10 }

		botao_y = margem_y + (8 * tamanho_casa) + 20
	}

	// Gerencia cliques e o ato de arrastar peças com o mouse
	funcao processar_mouse()
	{
		inteiro x, y, linha, coluna

		x = m.posicao_x()
		y = m.posicao_y()
		mouse_x = x
		mouse_y = y

		se (m.botao_pressionado(m.BOTAO_ESQUERDO))
		{
			// Tratamento caso haja uma solicitação de desistência ativa na tela
			se (solicitacao_desistencia != 0)
			{
				se (x >= 210 e x <= 300 e y >= 360 e y <= 400)
				{
					efetivar_desistencia()
					u.aguarde(300)
					retorne
				}
				se (x >= 320 e x <= 410 e y >= 360 e y <= 400)
				{
					solicitacao_desistencia = 0
					mensagem = "Desistência recusada."
					u.aguarde(300)
					retorne
				}
				retorne
			}

			se (nao arrastando)
			{
				// Botão: Voltar jogada
				se (x >= margem_x e x <= margem_x + 115 e y >= botao_y e y <= botao_y + 40)
				{
					voltar_jogada()
					u.aguarde(250)
					retorne
				}

				// Botão: Trilhas
				se (x >= margem_x + 125 e x <= margem_x + 245 e y >= botao_y e y <= botao_y + 40)
				{
					trilhas = nao trilhas
					se (trilhas)
					{
						mensagem = "Trilhas ativadas."
					}
					senao
					{
						mensagem = "Trilhas desativadas."
					}
					u.aguarde(250)
					retorne
				}

				// Botão: Empate
				se (x >= margem_x + 255 e x <= margem_x + 370 e y >= botao_y e y <= botao_y + 40)
				{
					processar_empate()
					u.aguarde(300)
					retorne
				}

				// Botão: Desistir
				se (x >= margem_x + 380 e x <= margem_x + 520 e y >= botao_y e y <= botao_y + 40)
				{
					pedir_desistencia()
					u.aguarde(300)
					retorne
				}

				// Botão: Tela Cheia
				se (x >= margem_x e x <= margem_x + 150 e y >= botao_y + 50 e y <= botao_y + 90)
				{
					alternar_tela_cheia()
					u.aguarde(400)
					retorne
				}

				se (encerrado)
				{
					mensagem = "Partida encerrada."
					retorne
				}

				linha = (y - margem_y) / tamanho_casa
				coluna = (x - margem_x) / tamanho_casa

				// Seleciona a peça se pertencer ao jogador da vez
				se (linha >= 0 e linha < 8 e coluna >= 0 e coluna < 8)
				{
					se (dono[linha][coluna] == turno)
					{
						arrastando = verdadeiro
						selecionada = verdadeiro
						origem_linha = linha
						origem_coluna = coluna
						sel_linha = linha
						sel_coluna = coluna
						mensagem = "Arrastando peça..."
					}
				}
			}
			retorne
		}

		// Ao soltar o botão do mouse, valida se o movimento é legal
		se (arrastando)
		{
			linha = (mouse_y - margem_y) / tamanho_casa
			coluna = (mouse_x - margem_x) / tamanho_casa

			se (linha < 0 ou linha >= 8 ou coluna < 0 ou coluna >= 8 ou (linha == origem_linha e coluna == origem_coluna))
			{
				cancelar_arrasto()
				mensagem = "Movimento cancelado."
				retorne
			}

			se (movimento_valido(origem_linha, origem_coluna, linha, coluna))
			{
				se (movimento_deixa_rei_em_xeque(origem_linha, origem_coluna, linha, coluna, turno))
				{
					mensagem = "Jogada proibida: Rei em xeque."
				}
				senao
				{
					realizar_movimento(origem_linha, origem_coluna, linha, coluna)
				}
			}
			senao
			{
				mensagem = "Movimento inválido."
			}

			cancelar_arrasto()
		}
	}

	funcao cancelar_arrasto()
	{
		arrastando = falso
		selecionada = falso
		origem_linha = -1
		origem_coluna = -1
		sel_linha = -1
		sel_coluna = -1
	}

	// Executa a movimentação oficial e troca o turno
	funcao realizar_movimento(inteiro origem_l, inteiro origem_c, inteiro destino_l, inteiro destino_c)
	{
		guardar_historico()

		dono[destino_l][destino_c] = dono[origem_l][origem_c]
		peca[destino_l][destino_c] = peca[origem_l][origem_c]

		dono[origem_l][origem_c] = 0
		peca[origem_l][origem_c] = " "

		s.reproduzir_som(som_movimento, falso)

		// Promoção automática do peão ao chegar no fim do tabuleiro
		se (peca[destino_l][destino_c] == "P" e (destino_l == 0 ou destino_l == 7))
		{
			peca[destino_l][destino_c] = "Q"
			mensagem = "Peão promovido a Dama."
		}
		senao
		{
			mensagem = "Jogada realizada."
		}

		se (turno == 1)
		{
			turno = 2
		}
		senao
		{
			turno = 1
		}
		
		atualizar_estado_jogo()
	}

	// Valida as regras de movimento geométricas de cada peça de xadrez
	funcao logico movimento_valido(inteiro origem_l, inteiro origem_c, inteiro destino_l, inteiro destino_c)
	{
		cadeia tipo
		inteiro dif_l, dif_c, abs_l, abs_c, direcao

		tipo = peca[origem_l][origem_c]
		se (dono[destino_l][destino_c] == turno) { retorne falso }

		dif_l = destino_l - origem_l
		dif_c = destino_c - origem_c
		
		se (dif_l < 0) { abs_l = -dif_l } senao { abs_l = dif_l }
		se (dif_c < 0) { abs_c = -dif_c } senao { abs_c = dif_c }

		// Regras do Peão
		se (tipo == "P")
		{
			se (turno == 2) { direcao = 1 } senao { direcao = -1 }
			
			se (destino_c == origem_c e destino_l == origem_l + direcao e dono[destino_l][destino_c] == 0) { retorne verdadeiro }
			se (destino_c == origem_c e dono[destino_l][destino_c] == 0)
			{
				se (turno == 1 e origem_l == 6 e destino_l == 4 e dono[5][origem_c] == 0) { retorne verdadeiro }
				se (turno == 2 e origem_l == 1 e destino_l == 3 e dono[2][origem_c] == 0) { retorne verdadeiro }
			}
			se (abs_c == 1 e destino_l == origem_l + direcao e dono[destino_l][destino_c] != 0) { retorne verdadeiro }
			retorne falso
		}

		// Regras do Rei, Cavalo, Torre, Bispo e Dama
		se (tipo == "K" e abs_l <= 1 e abs_c <= 1) { retorne verdadeiro }
		se (tipo == "C" e ((abs_l == 2 e abs_c == 1) ou (abs_l == 1 e abs_c == 2))) { retorne verdadeiro }
		se (tipo == "T" e (dif_l == 0 ou dif_c == 0)) { retorne caminho_livre(origem_l, origem_c, destino_l, destino_c) }
		se (tipo == "B" e abs_l == abs_c) { retorne caminho_livre(origem_l, origem_c, destino_l, destino_c) }
		se (tipo == "Q" e (dif_l == 0 ou dif_c == 0 ou abs_l == abs_c)) { retorne caminho_livre(origem_l, origem_c, destino_l, destino_c) }

		retorne falso
	}

	// Verifica se há peças bloqueando o caminho de Torres, Bispos ou Damas
	funcao logico caminho_livre(inteiro origem_l, inteiro origem_c, inteiro destino_l, inteiro destino_c)
	{
		inteiro passo_l = 0, passo_c = 0, l, c

		se (destino_l > origem_l) { passo_l = 1 }
		se (destino_l < origem_l) { passo_l = -1 }
		se (destino_c > origem_c) { passo_c = 1 }
		se (destino_c < origem_c) { passo_c = -1 }

		l = origem_l + passo_l
		c = origem_c + passo_c

		enquanto (l != destino_l ou c != destino_c)
		{
			se (dono[l][c] != 0) { retorne falso }
			l = l + passo_l
			c = c + passo_c
		}
		retorne verdadeiro
	}

	funcao inteiro encontrar_rei_linha(inteiro jogador)
	{
		para (inteiro l = 0; l < 8; l++)
		{
			para (inteiro c = 0; c < 8; c++)
			{
				se (dono[l][c] == jogador e peca[l][c] == "K") { retorne l }
			}
		}
		retorne -1
	}

	funcao inteiro encontrar_rei_coluna(inteiro jogador)
	{
		para (inteiro l = 0; l < 8; l++)
		{
			para (inteiro c = 0; c < 8; c++)
			{
				se (dono[l][c] == jogador e peca[l][c] == "K") { retorne c }
			}
		}
		retorne -1
	}

	// Checa se uma casa específica está sob ataque inimigo
	funcao logico casa_atacada(inteiro alvo_l, inteiro alvo_c, inteiro atacante)
	{
		inteiro l, c, dif_l, dif_c, abs_l, abs_c
		cadeia tipo

		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				se (dono[l][c] == atacante)
				{
					tipo = peca[l][c]
					dif_l = alvo_l - l
					dif_c = alvo_c - c
					
					se (dif_l < 0) { abs_l = -dif_l } senao { abs_l = dif_l }
					se (dif_c < 0) { abs_c = -dif_c } senao { abs_c = dif_c }

					se (tipo == "P")
					{
						se (atacante == 1 e alvo_l == l - 1 e abs_c == 1) { retorne verdadeiro }
						se (atacante == 2 e alvo_l == l + 1 e abs_c == 1) { retorne verdadeiro }
					}
					senao se (tipo == "C" e ((abs_l == 2 e abs_c == 1) ou (abs_l == 1 e abs_c == 2))) { retorne verdadeiro }
					senao se (tipo == "K" e abs_l <= 1 e abs_c <= 1) { retorne verdadeiro }
					senao se (tipo == "T" e (dif_l == 0 ou dif_c == 0) e caminho_livre(l, c, alvo_l, alvo_c)) { retorne verdadeiro }
					senao se (tipo == "B" e abs_l == abs_c e caminho_livre(l, c, alvo_l, alvo_c)) { retorne verdadeiro }
					senao se (tipo == "Q" e (dif_l == 0 ou dif_c == 0 ou abs_l == abs_c) e caminho_livre(l, c, alvo_l, alvo_c)) { retorne verdadeiro }
				}
			}
		}
		retorne falso
	}

	funcao logico rei_em_xeque(inteiro jogador)
	{
		inteiro linha, coluna, adversario
		linha = encontrar_rei_linha(jogador)
		coluna = encontrar_rei_coluna(jogador)

		se (linha == -1 ou coluna == -1) { retorne verdadeiro }
		
		se (jogador == 2) { adversario = 1 } senao { adversario = 2 }
		
		retorne casa_atacada(linha, coluna, adversario)
	}

	// Simula um movimento para garantir que ele não deixará o próprio rei em xeque
	funcao logico movimento_deixa_rei_em_xeque(inteiro origem_l, inteiro origem_c, inteiro destino_l, inteiro destino_c, inteiro jogador)
	{
		inteiro dono_origem, dono_destino
		cadeia peca_origem, peca_destino
		logico resultado

		dono_origem = dono[origem_l][origem_c]
		peca_origem = peca[origem_l][origem_c]
		dono_destino = dono[destino_l][destino_c]
		peca_destino = peca[destino_l][destino_c]

		dono[destino_l][destino_c] = dono_origem
		peca[destino_l][destino_c] = peca_origem
		dono[origem_l][origem_c] = 0
		peca[origem_l][origem_c] = " "

		resultado = rei_em_xeque(jogador)

		dono[origem_l][origem_c] = dono_origem
		peca[origem_l][origem_c] = peca_origem
		dono[destino_l][destino_c] = dono_destino
		peca[destino_l][destino_c] = peca_destino

		retorne resultado
	}

	funcao logico existe_jogada_legal(inteiro jogador)
	{
		inteiro l1, c1, l2, c2, turno_antigo

		turno_antigo = turno
		turno = jogador

		para (l1 = 0; l1 < 8; l1++)
		{
			para (c1 = 0; c1 < 8; c1++)
			{
				se (dono[l1][c1] == jogador)
				{
					para (l2 = 0; l2 < 8; l2++)
					{
						para (c2 = 0; c2 < 8; c2++)
						{
							se (movimento_valido(l1, c1, l2, c2) e nao movimento_deixa_rei_em_xeque(l1, c1, l2, c2, jogador))
							{
								turno = turno_antigo
								retorne verdadeiro
							}
						}
					}
				}
			}
		}

		turno = turno_antigo
		retorne falso
	}

	// Atualiza o estado atual da partida (verificando se houve xeque ou xeque-mate)
	funcao atualizar_estado_jogo()
	{
		jogador1_em_xeque = rei_em_xeque(1)
		jogador2_em_xeque = rei_em_xeque(2)
		jogador1_mate = falso
		jogador2_mate = falso

		se (turno == 1 e jogador1_em_xeque)
		{
			se (nao existe_jogada_legal(1))
			{
				jogador1_mate = verdadeiro
				encerrado = verdadeiro
				mensagem = "XEQUE-MATE! JOGADOR 2 VENCEU!"
			}
			senao { mensagem = "XEQUE! Rei em perigo." }
		}

		se (turno == 2 e jogador2_em_xeque)
		{
			se (nao existe_jogada_legal(2))
			{
				jogador2_mate = verdadeiro
				encerrado = verdadeiro
				mensagem = "XEQUE-MATE! JOGADOR 1 VENCEU!"
			}
			senao { mensagem = "XEQUE! Rei em perigo." }
		}
	}

	// Salva o estado atual na matriz de histórico
	funcao guardar_historico()
	{
		inteiro l, c, posicao
		se (quantidade_historico >= 50) { retorne }

		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				posicao = l * 8 + c
				historico_dono[quantidade_historico][posicao] = dono[l][c]
				historico_peca[quantidade_historico][posicao] = peca[l][c]
			}
		}

		historico_turno[quantidade_historico] = turno
		quantidade_historico++
	}

	// Desfaz a última jogada realizada
	funcao voltar_jogada()
	{
		inteiro l, c, posicao
		se (quantidade_historico <= 0)
		{
			mensagem = "Impossível voltar jogada."
			retorne
		}

		quantidade_historico--

		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				posicao = l * 8 + c
				dono[l][c] = historico_dono[quantidade_historico][posicao]
				peca[l][c] = historico_peca[quantidade_historico][posicao]
			}
		}

		turno = historico_turno[quantidade_historico]
		encerrado = falso
		proposta_empate = 0
		solicitacao_desistencia = 0
		cancelar_arrasto()
		atualizar_estado_jogo()
		mensagem = "Jogada desfeita."
	}

	funcao processar_empate()
	{
		se (encerrado) { retorne }
		se (proposta_empate == 0)
		{
			proposta_empate = turno
			mensagem = "Empate proposto. O oponente deve aceitar."
			retorne
		}
		se (proposta_empate == turno) { retorne }
		encerrado = verdadeiro
		proposta_empate = 0
		cancelar_arrasto()
		mensagem = "EMPATE ACORDADO!"
	}

	funcao pedir_desistencia()
	{
		se (encerrado) { retorne }
		solicitacao_desistencia = turno
		tempo_inicio_desistencia = u.tempo_decorrido()
		mensagem = "Desistência solicitada. Confirme no painel."
	}

	funcao processar_tempo_desistencia()
	{
		se (solicitacao_desistencia != 0)
		{
			inteiro decorrido = (u.tempo_decorrido() - tempo_inicio_desistencia) / 1000
			se (decorrido >= 10)
			{
				solicitacao_desistencia = 0
				mensagem = "Tempo de desistência expirado."
			}
		}
	}

	funcao efetivar_desistencia()
	{
		encerrado = verdadeiro
		cancelar_arrasto()
		se (solicitacao_desistencia == 1)
		{
			mensagem = "J1 desistiu. J2 VENCEU!"
			jogador2_mate = verdadeiro
		}
		senao
		{
			mensagem = "J2 desistiu. J1 VENCEU!"
			jogador1_mate = verdadeiro
		}
		solicitacao_desistencia = 0
	}

	funcao alternar_tela_cheia()
	{
		se (tela_cheia) { g.sair_modo_tela_cheia() tela_cheia = falso }
		senao { g.entrar_modo_tela_cheia() tela_cheia = verdadeiro }
		atualizar_layout()
	}

	// Função central de renderização gráfica na tela
	funcao desenhar_tudo()
	{
		g.definir_cor(0x18232F)
		g.limpar()

		desenhar_tabuleiro()
		se (trilhas e selecionada) { desenhar_trilhas() }
		desenhar_pecas()
		desenhar_botoes()
		desenhar_status()

		se (solicitacao_desistencia != 0) { desenhar_caixa_desistencia() }
		g.renderizar()
	}

	funcao desenhar_tabuleiro()
	{
		inteiro l, c, x, y
		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				x = margem_x + c * tamanho_casa
				y = margem_y + l * tamanho_casa

				se ((l + c) % 2 == 0) { g.definir_cor(0xECF0F1) }
				senao { g.definir_cor(0x7F8C8D) }

				se (selecionada e l == sel_linha e c == sel_coluna) { g.definir_cor(0xF1C40F) }

				g.desenhar_retangulo(x, y, tamanho_casa, tamanho_casa, falso, verdadeiro)
				g.definir_cor(0x222222)
				g.desenhar_retangulo(x, y, tamanho_casa, tamanho_casa, falso, falso)
			}
		}
	}

	// Desenha as bolinhas verdes de marcação de movimento válido
	funcao desenhar_trilhas()
	{
		inteiro l, c, x, y, raio = tamanho_casa / 4

		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				se (movimento_valido(sel_linha, sel_coluna, l, c) e nao movimento_deixa_rei_em_xeque(sel_linha, sel_coluna, l, c, turno))
				{
					x = margem_x + c * tamanho_casa + (tamanho_casa / 2) - (raio / 2)
					y = margem_y + l * tamanho_casa + (tamanho_casa / 2) - (raio / 2)
					g.definir_cor(0x27AE60)
					g.desenhar_elipse(x, y, raio, raio, verdadeiro)
				}
			}
		}
	}

	funcao desenhar_pecas()
	{
		inteiro l, c, x, y
		para (l = 0; l < 8; l++)
		{
			para (c = 0; c < 8; c++)
			{
				se (dono[l][c] != 0)
				{
					se (nao (arrastando e l == origem_linha e c == origem_coluna))
					{
						x = margem_x + c * tamanho_casa
						y = margem_y + l * tamanho_casa
						desenhar_peca(x, y, dono[l][c], peca[l][c])
					}
				}
			}
		}
		se (arrastando) { desenhar_peca_arrastada() }
	}

	// Desenha o círculo base e a letra identificadora da peça
	funcao desenhar_peca(inteiro x, inteiro y, inteiro jogador, cadeia letra)
	{
		inteiro cx, cy, raio

		cx = x + tamanho_casa / 2
		cy = y + tamanho_casa / 2
		raio = (tamanho_casa * 75) / 200

		se (jogador == 1) { g.definir_cor(0xFFFFFF) }
		senao { g.definir_cor(0x222222) }
		g.desenhar_elipse(cx - raio, cy - raio, raio * 2, raio * 2, verdadeiro)

		se (jogador == 1) { g.definir_cor(0x333333) }
		senao { g.definir_cor(0xCCCCCC) }
		g.desenhar_elipse(cx - raio, cy - raio, raio * 2, raio * 2, falso)

		se (jogador == 1) { g.definir_cor(0x111111) }
		senao { g.definir_cor(0xFFFFFF) }

		g.definir_tamanho_texto((tamanho_casa * 45) / 100)
		g.desenhar_texto(cx - (tamanho_casa * 15) / 100, cy - (tamanho_casa * 32) / 100, letra)
	}

	funcao desenhar_peca_arrastada()
	{
		se (origem_linha < 0 ou origem_linha >= 8 ou origem_coluna < 0 ou origem_coluna >= 8) { retorne }
		inteiro x = mouse_x - tamanho_casa / 2
		inteiro y = mouse_y - tamanho_casa / 2
		desenhar_peca(x, y, dono[origem_linha][origem_coluna], peca[origem_linha][origem_coluna])
	}

	// Desenha os botões de controle na interface
	funcao desenhar_botoes()
	{
		g.definir_cor(0x34495E) 
		g.desenhar_retangulo(margem_x, botao_y, 115, 40, verdadeiro, verdadeiro)
		
		se (trilhas) { g.definir_cor(0x27AE60) } 
		senao { g.definir_cor(0x34495E) }
		
		g.desenhar_retangulo(margem_x + 125, botao_y, 120, 40, verdadeiro, verdadeiro)
		g.definir_cor(0x8E44AD) g.desenhar_retangulo(margem_x + 255, botao_y, 115, 40, verdadeiro, verdadeiro)
		g.definir_cor(0xC0392B) g.desenhar_retangulo(margem_x + 380, botao_y, 140, 40, verdadeiro, verdadeiro)
		g.definir_cor(0x16A085) g.desenhar_retangulo(margem_x, botao_y + 50, 150, 40, verdadeiro, verdadeiro)

		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(14.0)
		g.desenhar_texto(margem_x + 28, botao_y + 25, "VOLTAR")
		g.desenhar_texto(margem_x + 151, botao_y + 25, "TRILHAS")
		g.desenhar_texto(margem_x + 278, botao_y + 25, "EMPATE")
		g.desenhar_texto(margem_x + 416, botao_y + 25, "DESISTIR")
		
		se (tela_cheia)
		{
			g.desenhar_texto(margem_x + 25, botao_y + 75, "SAIR TELA CHEIA")
		}
		senao
		{
			g.desenhar_texto(margem_x + 25, botao_y + 75, "TELA CHEIA")
		}
	}

	funcao desenhar_caixa_desistencia()
	{
		inteiro decorrido = (u.tempo_decorrido() - tempo_inicio_desistencia) / 1000
		inteiro restantes = 10 - decorrido
		se (restantes < 0) { restantes = 0 }

		g.definir_cor(0x111111) g.desenhar_retangulo(130, 270, 360, 160, verdadeiro, verdadeiro)
		g.definir_cor(0xE74C3C) g.desenhar_retangulo(130, 270, 360, 160, falso, falso)

		g.definir_cor(g.COR_BRANCO)
		g.definir_tamanho_texto(14.0)
		
		cadeia texto_des
		se (solicitacao_desistencia == 1)
		{
			texto_des = "J1 quer desistir. J2 aceita?"
		}
		senao
		{
			texto_des = "J2 quer desistir. J1 aceita?"
		}
		
		g.desenhar_texto(150, 300, texto_des + " (" + restantes + "s)")

		g.definir_cor(0x27AE60) g.desenhar_retangulo(210, 360, 90, 40, verdadeiro, verdadeiro)
		g.definir_cor(g.COR_BRANCO) g.desenhar_texto(240, 385, "SIM")

		g.definir_cor(0xC0392B) g.desenhar_retangulo(320, 360, 90, 40, verdadeiro, verdadeiro)
		g.definir_cor(g.COR_BRANCO) g.desenhar_texto(350, 385, "NÃO")
	}

	// Mostra na tela o status da partida, turnos e mensagens de feedback
	funcao desenhar_status()
	{
		g.definir_tamanho_texto(16.0)

		se (jogador1_mate ou jogador2_mate)
		{
			g.definir_cor(0x2ECC71)
			g.desenhar_texto(margem_x, botao_y + 110, "FIM DE JOGO - XEQUE-MATE!")
			retorne
		}

		se (jogador1_em_xeque ou jogador2_em_xeque)
		{
			g.definir_cor(0xE67E22)
			g.desenhar_texto(margem_x, botao_y + 110, "XEQUE! Rei ameaçado.")
		}
		senao
		{
			g.definir_cor(g.COR_BRANCO)
			se (turno == 1)
			{
				g.desenhar_texto(margem_x, botao_y + 110, "VEZ: JOGADOR 1 (BRANCAS)")
			}
			senao
			{
				g.desenhar_texto(margem_x, botao_y + 110, "VEZ: JOGADOR 2 (PRETAS)")
			}
		}

		g.definir_cor(0xBDC3C7)
		g.definir_tamanho_texto(14.0)
		g.desenhar_texto(margem_x, botao_y + 135, mensagem)
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 22735; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */