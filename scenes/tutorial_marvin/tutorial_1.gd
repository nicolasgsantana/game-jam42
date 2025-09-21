extends Node2D

# Variáveis para controlar a velocidade do texto
var texto_completo = ""
var texto_atual = ""
var indice_palavra = 0
var palavras = []
var tempo_entre_palavras = 0.2  # Ajuste este valor para mudar a velocidade
var timer = 0.0
var escrevendo = false

func _ready():
	# Pega o texto inicial do RichTextLabel
	texto_completo = self.text
	self.text = ""  # Limpa o texto inicial
	palavras = texto_completo.split(" ")
	escrevendo = true

func _process(delta):
	if escrevendo:
		timer += delta
		
		if timer >= tempo_entre_palavras:
			timer = 0.0
			
			if indice_palavra < palavras.size():
				# Adiciona a próxima palavra
				if indice_palavra > 0:
					texto_atual += " " + palavras[indice_palavra]
				else:
					texto_atual = palavras[indice_palavra]
				
				self.text = texto_atual
				indice_palavra += 1
			else:
				escrevendo = false  # Terminou de escrever

# Função para iniciar o efeito (útil se quiser reutilizar)
func iniciar_escrita(novo_texto = ""):
	if novo_texto != "":
		texto_completo = novo_texto
	
	texto_atual = ""
	indice_palavra = 0
	palavras = texto_completo.split(" ")
	escrevendo = true
	self.text = ""
