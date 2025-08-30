int andares = 20;
Pedidos p[] = new Pedidos[30];
Elevador e[] = new Elevador[5];
Central c = new Central(e.length);
int tempo = 0;

void setup() {
  frameRate(1);
  int tc[] = new int[p.length];
  int i[] = new int[p.length];
  int o[] = new int[p.length];
  
  for(int a = 0; a < p.length; a++) {
    tc[a] = int(random(1,60));
    i[a] = int(random(andares));
    o[a] = int(random(andares));
    p[a] = new Pedidos(tc[a], i[a], o[a], false, false);
  }
  
  for(int a = 0; a < e.length; a++) {
    e[a] = new Elevador(0, 5);
  }
  c = new Central(e.length);
}

void draw() {
  tempo++;
  
  c.calculosIniciais();
  c.calculosFinais();
  c.lixeira();
  c.logEnxuto();
  
  if (!c.existemPedidos()) {
    println("--- SIMULAÇÃO CONCLUÍDA NO TEMPO: " + tempo + " ---");
    noLoop();
  }
}

class Pedidos {
  int tempoChamado, origem, destino, direcao;
  boolean embarque, desembarque;
  boolean atribuido = false;
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
  void validacao() {
    if(origem == destino) valido = false;
  }
}

class Elevador {
  ArrayList<Pedidos> pedidos = new ArrayList<Pedidos>();
  int andar, capacidade;
  int sentido = 0;
  int deslocamento = 1;
  boolean espaco;
  boolean tarefaParaCima = false, tarefaParaBaixo = false;
  Elevador(int andar, int capacidade) {
    this.andar = andar;
    this.capacidade = capacidade;
  }
  int lotacao() {
    int pessoas = 0;
    for(int a = 0; a < pedidos.size(); a++) {
      Pedidos pedidoTemporario = pedidos.get(a);
      if(pedidoTemporario.embarque && !pedidoTemporario.desembarque) pessoas +=1;
    }
    return pessoas;
  }
}

class Central {
  int elevadores;
  Central(int elevadores) {
    this.elevadores = elevadores;
  }
  void calculosIniciais() {
    acoesEmbarqueDesembarque();
    verificarPassageiros();
    decisaoCentral();
  }
  void calculosFinais() {
    decidirSentido();
    mudarSentido();
    acoesMovimento();
  }
  void lixeira() {
    eliminarPedidos();
  }
  void verificarPassageiros() {
    int memoriaLotacao = 0;
    for(int a = 0; a < e.length; a++) {
      memoriaLotacao = e[a].lotacao();
      if(memoriaLotacao >= e[a].capacidade) {
        e[a].espaco = false;
      } else {
          e[a].espaco = true;
        }
    }
  }
  void decisaoCentral() {
    int[] menorCusto = new int[p.length];
    for(int a = 0; a < p.length; a++) {
      int indiceMenorCusto = -1;
      menorCusto[a] = andares + p.length;
      for(int b = 0; b < e.length; b++) {
        int custoIndividual = menorCusto[a];
        if(tempo >= p[a].tempoChamado && p[a].valido && !p[a].atribuido) {
          if(e[b].sentido == 0) {
            custoIndividual = custoOcioso(e[b].andar, p[a].origem);
          } else {
              custoIndividual = custoMovendo(e[b], p[a].origem);
            }
          if(custoIndividual < menorCusto[a]) {
            menorCusto[a] = custoIndividual;
            indiceMenorCusto = b;
          }
        }
      } 
      if(indiceMenorCusto != -1) {
        e[indiceMenorCusto].pedidos.add(p[a]);
        p[a].atribuido = true;
      }
    }
  }
  int custoOcioso(int andarElevador, int andarOrigem) {
    int custo = abs(andarElevador - andarOrigem);
    return custo;
  }
  //nao pensei nessa saida Elevador elevador, usei o gemini
  int custoMovendo(Elevador elevador, int andarOrigem) {
    int custo;
    int distancia = abs(elevador.andar - andarOrigem);
    if(elevador.sentido == 1 && elevador.andar < andarOrigem || 
      elevador.sentido == -1 && elevador.andar > andarOrigem) {
      custo = distancia + elevador.pedidos.size();
    } else {
        custo = andares + p.length;
      }
    return custo;
  }
  void decidirSentido() {
    for(int a = 0; a < e.length; a++) {
      e[a].tarefaParaCima = false;
      e[a].tarefaParaBaixo = false;
      
      for(int b = 0; b < e[a].pedidos.size(); b++) {
        if(((e[a].pedidos.get(b).origem > e[a].andar && !e[a].pedidos.get(b).embarque) ||
          (e[a].pedidos.get(b).destino > e[a].andar && e[a].pedidos.get(b).embarque)) && 
          e[a].pedidos.get(b).valido) {
            e[a].tarefaParaCima = true;
        } 
        if(((e[a].pedidos.get(b).origem < e[a].andar && !e[a].pedidos.get(b).embarque) ||
          (e[a].pedidos.get(b).destino < e[a].andar && e[a].pedidos.get(b).embarque)) && 
          e[a].pedidos.get(b).valido) {
            e[a].tarefaParaBaixo = true;
        }  
      }
    }
  }
  void mudarSentido() {
    for(int a = 0; a < e.length; a++) {
      if(e[a].pedidos.size() == 0) e[a].sentido = 0;
      if(e[a].tarefaParaCima && !e[a].tarefaParaBaixo) {
        e[a].sentido = 1;
      } else if(!e[a].tarefaParaCima && e[a].tarefaParaBaixo) {
        e[a].sentido = -1;
        } else if((e[a].tarefaParaCima && e[a].tarefaParaBaixo) && e[a].sentido != 0) {
          e[a].sentido = e[a].sentido;
          } else if((e[a].tarefaParaCima && e[a].tarefaParaBaixo) && e[a].sentido == 0) {
            e[a].sentido = 1;
            }
    }
  }
  void acoesMovimento() {
    for(int a = 0; a < e.length; a++) {
      e[a].andar += e[a].sentido * e[a].deslocamento;
    }
  }
  void acoesEmbarqueDesembarque() {
    for(int a = 0; a < e.length; a++) {
      e[a].deslocamento = 1;
      for(int b = 0; b < e[a].pedidos.size(); b++) {
         if(e[a].andar == e[a].pedidos.get(b).origem && !e[a].pedidos.get(b).embarque && e[a].espaco) {
           e[a].pedidos.get(b).embarque = true;
           e[a].deslocamento = 0;
         }
         if(e[a].andar == e[a].pedidos.get(b).destino && e[a].pedidos.get(b).embarque && !e[a].pedidos.get(b).desembarque) {
           e[a].pedidos.get(b).desembarque = true;
           e[a].deslocamento = 0;
         }
      }
    }
  }
  void eliminarPedidos() {
    for(int a = 0; a < e.length; a++) {
      for(int b = e[a].pedidos.size() - 1; b >= 0; b--) {
        if(e[a].pedidos.get(b).embarque && e[a].pedidos.get(b).desembarque) e[a].pedidos.remove(b);
      }
    }
  }
  boolean existemPedidos() {
    for(int a = 0; a < e.length; a++) {
      if(e[a].pedidos.size() > 0) {
        return true;
      }
    }
    for(int a = 0; a < p.length; a++) {
      if(p[a].valido && !p[a].atribuido) {
        return true;
            
      }
    } return false;
  }
  //log via gemini
  void logEnxuto() {
  
    String linhaDeLog = "Tempo: " + tempo + " | ";

    for (int i = 0; i < e.length; i++) {
    
      linhaDeLog += "E" + i + ": " + e[i].andar;
    
      if (e[i].sentido == 1) {
        linhaDeLog += "^ ";
      } else if (e[i].sentido == -1) {
        linhaDeLog += "v ";
      } else {
        linhaDeLog += "- ";
      }
    
      linhaDeLog += "(" + e[i].lotacao() + "/" + e[i].capacidade + ") ";
    
      linhaDeLog += "{";
      for (int j = 0; j < e[i].pedidos.size(); j++) {
        Pedidos tarefa = e[i].pedidos.get(j);
        linhaDeLog += tarefa.origem + "->" + tarefa.destino;
        if (j < e[i].pedidos.size() - 1) {
          linhaDeLog += ", ";
        }
      }
      linhaDeLog += "} | ";
    }
    println(linhaDeLog);
  }
}
