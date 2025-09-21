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
	"Veja aquele monstrinho ali? Ele tem um comando escrito acima dele.",
	"Digite exatamente aquilo no teclado, e puff... ele desaparece.",
	"Não esqueça de pressionar o enter",
	"Estou torcendo por você!"
]
var indice_fala_atual = 0

func _ready():
	# Inicia com a primeira fala
	iniciar_escrita(falas[indice_fala_atual])

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
			else:
				# Texto terminou de ser escrito
				escrevendo = false
				# Se for a última fala, fecha automaticamente
				if indice_fala_atual >= falas.size() - 1:
					fechar_dialogo()

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
	get_tree().quit()  # Fecha o jogo completamente
