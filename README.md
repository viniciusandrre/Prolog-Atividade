# Prolog-Atividade

## Nomes dos Integrantes:
- **Vinícius André Almeida Pereira** (almeida.vinicius@discente.ufma.br)
- **Lucyene Pinheiro Neves**
- **Emanuelle Da Silva Launé**

## Descrição do Projeto
Este projeto utiliza a linguagem de programação lógica Prolog para diagnosticar problemas mecânicos e elétricos em um veículo. Baseado em sintomas e leituras de sensores, o sistema infere possíveis causas e sugere recomendações de manutenção.

## Estrutura do Código
O código é dividido nas seguintes seções:
1. **Declaração de Predicados Dinâmicos**: Definição dos fatos e regras dinâmicas do sistema.
2. **Fatos Básicos (Sintomas e Causas)**: Lista de possíveis sintomas e suas causas associadas.
3. **Regras de Diagnóstico**: Conjunto de regras lógicas para inferir diagnósticos com base nas condições do veículo.
4. **Recomendações de Ação**: Sugestões de manutenção baseadas nos diagnósticos.
5. **Predicado Principal de Diagnóstico**: Procedimento que executa as inferências e apresenta os resultados.
6. **Justificativas para Cada Causa**: Explicações detalhadas para cada diagnóstico realizado.
7. **Casos de Teste**: Conjunto de testes para validar o funcionamento do sistema.

## Casos de Teste

### Caso de Teste 1: Partida Inconsistente
#### Entrada:
```prolog
caso_teste_1_partida_inconsistente :-
    write('=== Caso de Teste 1: Partida Inconsistente ==='), nl,
    limpar_estado,
    assertz(falha_ignicao),
    assertz(luz_bateria),
    assertz(bateria(11.8)),
    diagnosticar,
    limpar_estado.
```
#### Saída Esperada:
```
=== Caso de Teste 1: Partida Inconsistente ===
Possíveis problemas diagnosticados:

[bateria_fraca]

 -> Para bateria_fraca, recomenda-se:

 Recarregar ou substituir a bateria

-> Justificativa: 
 O sistema comparou 11,8V com o limite mínimo de 12V
 e concluiu que a bateria nao está fornecendo voltagem adequada.
 Em paralelo, detectou-se que a luz de bateria piscava, 
 indicando suspeita no alternador. 
 Portanto, prioriza-se bateria fraca, mas, se recarregada 
 e o problema continuar, passa a se investigar alternador.
```

### Caso de Teste 2: Superaquecimento no Motor
#### Entrada:
```prolog
caso_teste_2_superaquecimento :-
    write('=== Caso de Teste 2: Superaquecimento no Motor ==='), nl,
    limpar_estado,
    assertz(temperatura_motor(105)),
    assertz(nivel_oleo(1.5)),
    assertz(luz_check_engine),
    diagnosticar,
    limpar_estado.
```
#### Saída Esperada:
```
=== Caso de Teste 2: Superaquecimento no Motor ===
Possíveis problemas diagnosticados:

[sistema_arrefecimento, baixo_nivel_oleo]

 -> Para sistema_arrefecimento, recomenda-se:

 Checar radiador, bomba d'água, ventoinha e fluido de arrefecimento

 -> Para baixo_nivel_oleo, recomenda-se:

 Verificar nível de óleo e possíveis vazamentos

-> Justificativa: 
A temperatura do motor está acima de 100°C, 
e a luz de check engine está acesa.
Isso indica um problema no sistema de arrefecimento.

-> Justificativa: 
O nível de óleo está abaixo do mínimo recomendado, 
o que pode causar danos ao motor.
```

### Caso de Teste 3: Motor Engasgado em Altas Rotações
#### Entrada:
```prolog
caso_teste_3_motor_engasgado_altas_rotacoes :-
    write('=== Caso de Teste 3: Motor Engasgado em Altas Rotações ==='), nl,
    limpar_estado,
    assertz(rotacao_alta),
    assertz(luz_check_engine),
    assertz(sensor_oxigenio(1.0)), % valor fora do normal
    diagnosticar,
    limpar_estado.
```
#### Saída Esperada:
```
=== Caso de Teste 3: Motor Engasgado em Altas Rotações ===
Possíveis problemas diagnosticados:

[problema_injecao]

 -> Para problema_injecao, recomenda-se:

 Verificar sistema de injeção eletrônica

-> Justificativa: 
Há falha em alta rotação, mas o sensor de oxigênio está na faixa normal. 
Isso sugere um problema no sistema de injeção.
```

### Caso de Teste 4: Ruídos no Motor ao Acelerar
#### Entrada:
```prolog
caso_teste_4_ruidos_ao_acelerar :-
    write('=== Caso de Teste 4: Ruídos no Motor ao Acelerar ==='), nl,
    limpar_estado,
    assertz(barulho_incomum),
    assertz(temperatura_motor(90)),  % dentro da faixa normal
    diagnosticar,
    limpar_estado.
```
#### Saída Esperada:
```
=== Caso de Teste 4: Ruídos no Motor ao Acelerar ===
Possíveis problemas diagnosticados:

[problema_transmissao]

 -> Para problema_transmissao, recomenda-se:

 Verificar caixa de câmbio e sistema de transmissão

-> Justificativa: 
Há barulhos incomuns no motor, mas a temperatura está normal
e a luz de check engine não está acesa.
Isso sugere um problema na transmissão.
```

## Como Executar
Para rodar o diagnóstico, basta carregar o arquivo no ambiente Prolog e chamar o predicado `diagnosticar.` ou um dos casos de teste `caso_teste_X.` para verificar o funcionamento do sistema.

## Conclusão
Este sistema demonstra a aplicação da lógica Prolog para a detecção e diagnóstico de falhas mecânicas e elétricas em veículos, facilitando a manutenção preventiva e corretiva.

