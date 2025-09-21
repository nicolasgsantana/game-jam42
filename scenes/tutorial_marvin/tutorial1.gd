extends RichTextLabel

# Variáveis para controlar a velocidade do texto
var texto_completo = ""
var texto_atual = ""
var indice_caractere = 0
var tempo_entre_caracteres = 0.05
var timer = 0.0
var escrevendo = false

# Lista de falas
var falas = [
	"Ah, claro... mais um dia glorioso, tentando salvar",
	"mentes humanas preguiçosas de suas próprias decisões...",
	"De novo!",
	"Sim, sua vida depende de pressionar teclas",
	"corretamente.",
	"Estou tão entusiasmado quanto você imagina...",
	"menos, talvez.",
	"Olhe, humano. Se você não digitar os comandos corretos",
	"os monstros vão continuar destruindo seus projetos.",
	"Nada pessoal.",
	"..."
]
var indice_fala_atual = 0

# Variáveis de áudio
var audio_player: AudioStreamPlayer
var som_tecla: AudioStream

func _ready():
	# Inicia com a primeira fala
	iniciar_escrita(falas[indice_fala_atual])
	
	# Configura o sistema de áudio
	setup_audio()

func setup_audio():
	# Cria um AudioStreamPlayer como filho deste nó
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	# Carrega o som (ajuste o caminho para seu arquivo de som)
	som_tecla = preload("res://sounds/Mech_Step_1.wav")  # Ou .mp3, .ogg
	
	# Se não encontrar o arquivo, cria um som padrão
	if som_tecla == null:
		print("Arquivo de som não encontrado. Usando som padrão.")
		# Você pode adicionar um gerador de som procedural aqui se quiser

func _process(delta):
	if escrevendo:
		timer += delta
		
		if timer >= tempo_entre_caracteres:
			timer = 0.0
			
			if indice_caractere < texto_completo.length():
				# Adiciona o próximo caractere
				texto_atual += texto_completo[indice_caractere]
				self.text = texto_atual
				indice_caractere += 1
				
				# Toca som para cada caractere (exceto espaços)
				tocar_som_tecla(texto_completo[indice_caractere - 1])
			else:
				# Texto terminou de ser escrito
				escrevendo = false
				# Se for a última fala, fecha automaticamente
				if indice_fala_atual >= falas.size() - 1:
					fechar_dialogo()

func tocar_som_tecla(caractere):
	# Não toca som para espaços ou pontuação (opcional)
	if caractere == " " or caractere in [".", ",", "!", "?", "..."]:
		return
	
	# Configura e toca o som
	if audio_player and som_tecla:
		audio_player.stream = som_tecla
		audio_player.volume_db = -10  # Ajuste o volume (-10 é mais baixo)
		audio_player.pitch_scale = randf_range(0.9, 1.1)  # Variação de pitch
		audio_player.play()

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			# Se estiver escrevendo, completa o texto imediatamente
			if escrevendo:
				completar_texto()
			else:
				# Se não estiver escrevendo, vai para a próxima fala
				proxima_fala()

func completar_texto():
	# Completa o texto atual imediatamente
	self.text = texto_completo
	texto_atual = texto_completo
	indice_caractere = texto_completo.length()
	escrevendo = false
	
	# Para o som se estiver tocando
	if audio_player and audio_player.playing:
		audio_player.stop()
	
	# Se for a última fala, fecha automaticamente após completar
	if indice_fala_atual >= falas.size() - 1:
		fechar_dialogo()

func proxima_fala():
	# Avança para a próxima fala
	indice_fala_atual += 1
	
	# Se chegou ao final, fecha o diálogo
	if indice_fala_atual >= falas.size():
		fechar_dialogo()
		return
	
	# Inicia a escrita da nova fala
	iniciar_escrita(falas[indice_fala_atual])

func iniciar_escrita(novo_texto):
	texto_completo = novo_texto
	texto_atual = ""
	indice_caractere = 0
	escrevendo = true
	self.text = ""

func fechar_dialogo():
	# Fecha a cena atual
	get_tree().quit()
