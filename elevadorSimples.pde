Pedidos p[] = new Pedidos[30];
Elevador e[] = new Elevador[1];
int tempo = 0;
int indicePedidoFinal;

void setup() {
  frameRate(10);
  int tc[] = new int[p.length];
  int i[] = new int[p.length];
  int o[] = new int[p.length];
  
  for(int a = 0; a < p.length; a++) {
    tc[a] = int(random(1, 60));
    i[a] = int(random(20));
    o[a] = int(random(20));
    p[a] = new Pedidos(tc[a], i[a], o[a], false, false);
  }
  
  int pedidoFinal = 0;
  for(int a = 0; a < p.length; a++) {
    if(tc[a] > pedidoFinal) {
      pedidoFinal = tc[a];
      indicePedidoFinal = a;
    }
  }
  for(int a = 0; a < e.length; a++) {
    e[a] = new Elevador(0, 5);
  }
}

void draw() {
  tempo++;
  e[0].calculoPassageiros();
  e[0].calculoInternoElevador();
  e[0].acoes();
  
  //log feito por IA
  println("=== Tempo: " + tempo + " | Andar atual do elevador: " + e[0].andar + " ===");

  for (int i = 0; i < p.length; i++) {
    if (p[i].embarque && !p[i].desembarque) {
      println(
        "Pedido[" + i + "] | Origem: " + p[i].origem + 
        " → Destino: " + p[i].destino + 
        " | Direção: " + p[i].direcao);
    }
  }

  println("Espaço disponível no elevador: " + e[0].espaco);
  println("Elevador está vazio? " + e[0].vazio);
  println("Sentido atual: " + e[0].sentido);
  if(e[0].vazio && 
    p[indicePedidoFinal].desembarque && 
    p[indicePedidoFinal].valido) {
      println("não há mais pedidos");
      noLoop();
  }
  println("");
  
  e[0].movimento();
}

class Pedidos {
  int tempoChamado, origem, destino, direcao, tempoEmbarque;
  float urgenciaExterna, urgenciaInterna;
  boolean embarque, desembarque;
  boolean valido = true;
  Pedidos(int tempoChamado, int origem, int destino, boolean embarque, boolean desembarque) {
    this.tempoChamado = tempoChamado;
    this.origem = origem;
    this.destino = destino;
    this.embarque = embarque;
    this.desembarque = desembarque;
    direcao();
  }
  int direcao() {
    if(destino > origem) {
      direcao = 1;
    } 
    if(destino < origem) {
      direcao = -1;
    }
    if(origem == destino) {
      valido = false;
    }
    return direcao;
  }
}

class Elevador {
  int andar, capacidade;
  int sentido = 1;
  int deslocamento = 1;
  int indicePrioridadeExterna, indicePrioridadeInterna;
  boolean houveEmbarqueDesembarque;
  boolean vazio, espaco;
  Elevador(int andar, int capacidade) {
    this.andar = andar;
    this.capacidade = capacidade;
  }
  void calculoPassageiros() {
    ocupacao();
    prioridadeExterna();
    carga();
  }
  void calculoInternoElevador() {
    prioridadeInterna();
    inverterSentido();
    controleSentido();
  }
  void movimento() {
    movimentoEnquantoVazio();
    movimentoOcupado();
  }
  int prioridadeExterna() {
    float maiorUrgenciaAtual = -1;
    indicePrioridadeExterna = -1;
    for(int a = 0;  a < p.length; a++) {
      if(p[a].valido && tempo > p[a].tempoChamado && !p[a].embarque) {
        p[a].urgenciaExterna = (tempo -p[a].tempoChamado) + 1.0f/ (1 + abs(andar - p[a].origem));
        if(p[a].urgenciaExterna > maiorUrgenciaAtual) {
          maiorUrgenciaAtual = p[a].urgenciaExterna;
          indicePrioridadeExterna = a;
        }
      }
    } return indicePrioridadeExterna;
  }
  int prioridadeInterna() {
    float maiorUrgenciaInterna = -1;
    indicePrioridadeInterna = -1;
    for(int a = 0;  a < p.length; a++) {
      if(p[a].valido && p[a].embarque && !p[a].desembarque) {
        p[a].urgenciaInterna = (tempo -p[a].tempoEmbarque) + 1.0f/ (1 + abs(andar - p[a].destino));
        if(p[a].urgenciaInterna > maiorUrgenciaInterna) {
          maiorUrgenciaInterna = p[a].urgenciaInterna;
          indicePrioridadeInterna = a;
        }
      }
    } return indicePrioridadeInterna;
  }
  void ocupacao() {
    vazio = true;
    for(int a = 0; a < p.length; a++) {
      if(p[a].embarque && !p[a].desembarque) vazio = false;
    }
  }
  void carga() {
    int pessoas = 0;
    for(int a = 0; a < p.length; a++) {
      if(p[a].valido && p[a].embarque && !p[a].desembarque) pessoas +=1;
    }
    if(pessoas >= capacidade) {
      espaco = false;
    } else {
      espaco = true;
      }
  }
  void movimentoEnquantoVazio() {
    if(indicePrioridadeExterna != -1) {
      if(vazio && andar < p[indicePrioridadeExterna].origem) {
        andar += deslocamento;
      } else if(vazio && andar > p[indicePrioridadeExterna].origem) {
        andar -= deslocamento;
        }
    }
  }
  void movimentoOcupado() {
    if(indicePrioridadeInterna != -1) {
      if(!vazio) andar += sentido * deslocamento;
    }
  }
  void acoes() {
    deslocamento = 1;
    houveEmbarqueDesembarque = false;
    for(int a = 0; a < p.length; a++) {
      if(p[a].valido && tempo >= p[a].tempoChamado && andar == p[a].origem && !p[a].embarque && espaco) {
        p[a].embarque = true;
        houveEmbarqueDesembarque = true;
        p[a].tempoEmbarque = tempo;
      }
      if(andar == p[a].destino && p[a].embarque && !p[a].desembarque) {
        p[a].desembarque = true;
        houveEmbarqueDesembarque = true;
      }
    }
    if(houveEmbarqueDesembarque) deslocamento =0;
  }
  boolean inverterSentido() {
    for(int a = 0; a < p.length; a++) {
      if(p[a].embarque && !p[a].desembarque && sentido == p[a].direcao) return false;
    } return true;
  }
  void controleSentido() {
    boolean verificarInversao = inverterSentido();
    if(verificarInversao) {
      sentido = -sentido;
    }
    if(vazio) sentido = 1;
  }
}
