/*********************************************
 * 1. DECLARAÇÃO DE PREDICADOS DINÂMICOS
 *********************************************/
:- dynamic(bateria/1).
:- dynamic(temperatura_motor/1).
:- dynamic(nivel_oleo/1).
:- dynamic(sensor_oxigenio/1).
:- dynamic(luz_check_engine/0).
:- dynamic(luz_bateria/0).
:- dynamic(falha_ignicao/0).
:- dynamic(barulho_incomum/0).
:- dynamic(rotacao_alta/0).

/*********************************************
 * 2. FATOS BÁSICOS (SINTOMAS E CAUSAS)
 *    - Aqui definimos sintomas e as possíveis
 *      causas associadas a cada um deles. (não mexer)
 *********************************************/

/* Exemplos de causas representadas por termos que
   indicam possíveis problemas */
causa(bateria_fraca).
causa(alternador_defeituoso).
causa(sistema_arrefecimento).
causa(baixo_nivel_oleo).
causa(vela_ignicao_defeituosa).
causa(sensor_oxigenio_defeituoso).
causa(problema_injecao).
causa(problema_transmissao).
causa(problema_interno_motor).  % Ex.: biela, pistão, etc.

/*********************************************
 * 3. REGRAS DE DIAGNÓSTICO PRINCIPAIS
 *    - Se determinados sintomas e leituras
 *      de sensores estiverem presentes,
 *      inferimos a causa provável.
 *********************************************/

% 3.1 Diagnóstico de bateria fraca
%    - Se há falha de ignição, luz de bateria acesa
%      e tensão da bateria < 12, conclui-se bateria_fraca.
diagnostico(bateria_fraca) :-
    falha_ignicao,
    luz_bateria,
    bateria(Voltage),
    Voltage < 12.

% 3.2 Diagnóstico de alternador defeituoso
%    - Se a bateria está fraca mesmo após recarga,
%      ou se a luz de bateria acende durante o uso,
%      suspeita do alternador.
diagnostico(alternador_defeituoso) :-
    luz_bateria,
    \+ diagnostico(bateria_fraca).  
    /* Se não foi diagnosticada bateria_fraca,
       mas a luz continua acesa, pode ser alternador. */

% 3.3 Diagnóstico de superaquecimento / sistema de arrefecimento
%    - Se temperatura do motor > 100°C e/ou check engine aceso,
%      indicamos problema de arrefecimento.
diagnostico(sistema_arrefecimento) :-
    temperatura_motor(Temp),
    Temp > 100,
    luz_check_engine.

% 3.4 Diagnóstico de baixo nível de óleo
%    - Se nível do óleo está abaixo do mínimo,
%      sugerimos problema relacionado ao óleo.
diagnostico(baixo_nivel_oleo) :-
    nivel_oleo(Nivel),
    Nivel < 2.0.  % Assumindo que 2.0 e o nivel minimo aceitavel.

% 3.5 Diagnóstico de vela de ignição defeituosa
%    - Se há falha de ignição frequente, mas a bateria está boa,
%      suspeitamos da vela de ignição.
diagnostico(vela_ignicao_defeituosa) :-
    falha_ignicao,
    \+ diagnostico(bateria_fraca).

% 3.6 Diagnóstico de sensor de oxigênio defeituoso
%    - Se o sensor de oxigênio marca valor fora da faixa normal
%      e a luz de check engine pisca somente em alta rotação,
%      pode ser o sensor de oxigênio.
diagnostico(sensor_oxigenio_defeituoso) :-
    sensor_oxigenio(Valor),
    Valor < 0.5,  % Valor fora da faixa normal
    rotacao_alta,
    luz_check_engine.

% 3.7 Diagnóstico de problema na injeção
%    - Se há falha em alta rotação e a leitura do sensor de
%      oxigênio está na faixa normal, pode ser a injeção.
diagnostico(problema_injecao) :-
    rotacao_alta,
    sensor_oxigenio(Valor),
    Valor >= 0.5,  % Valor na faixa normal
    luz_check_engine.

% 3.8 Diagnóstico de ruídos no motor (problema interno ou transmissão)
%    - Se há barulho incomum e perda de potência, mas a check engine
%      não acende, pode ser mecânico (bielas, transmissão etc.).
diagnostico(problema_interno_motor) :-
    barulho_incomum,
    \+ luz_check_engine,
    temperatura_motor(T),
    T < 100,  % Temperatura normal
    !.

diagnostico(problema_transmissao) :-
    barulho_incomum,
    \+ luz_check_engine,
    temperatura_motor(T),
    T < 100.

/*********************************************
 * 4. RECOMENDAÇÕES DE AÇÃO
 *    - Associa cada causa a uma recomendação
 *      de manutenção / correção.
 *********************************************/
recomendacao(bateria_fraca, 'Recarregar ou substituir a bateria').
recomendacao(alternador_defeituoso, 'Verificar correia do alternador ou trocar alternador').
recomendacao(sistema_arrefecimento, 'Checar radiador, bomba d\'água, ventoinha e fluido de arrefecimento').
recomendacao(baixo_nivel_oleo, 'Verificar nivel de oleo e possiveis vazamentos').
recomendacao(vela_ignicao_defeituosa, 'Substituir velas de ignicao').
recomendacao(sensor_oxigenio_defeituoso, 'Substituir sensor de oxigenio').
recomendacao(problema_injecao, 'Verificar sistema de injecao eletronica').
recomendacao(problema_interno_motor, 'Verificar bielas, pistoes e componentes internos do motor').
recomendacao(problema_transmissao, 'Verificar caixa de cambio e sistema de transmissao').

/*********************************************
 * 5. PREDICADO PRINCIPAL DE DIAGNÓSTICO
 *    - Identifica todas as causas possíveis,
 *      exibe as recomendações. (não mexer)
 *********************************************/
diagnosticar :-
    % Encontra todas as causas que satisfazem as regras
    findall(Causa, diagnostico(Causa), ListaCausas),
    (   ListaCausas \= []
    ->  format('Possiveis problemas diagnosticados:\n\n~w~n',[ListaCausas]), nl,
        listar_recomendacoes(ListaCausas), nl,
        listar_justificativas(ListaCausas)
    ;   write('Nenhum problema foi diagnosticado com as informacoes atuais.'), nl
    ).

% Lista as recomendacoes para cada causa
listar_recomendacoes([]).
listar_recomendacoes([Causa|Resto]) :-
    recomendacao(Causa, Rec),
    format(' -> Para ~w, recomenda-se:\n\n ~w~n\n', [Causa, Rec]),
    listar_recomendacoes(Resto).

% Lista as justificativas para cada causa
listar_justificativas([]).
listar_justificativas([Causa|Resto]) :-
    justificativa(Causa, Just),
    format('-> Justificativa: ~n~w~n', [Just]),
    listar_justificativas(Resto). 

/*********************************************
 * 6. JUSTIFICATIVAS PARA CADA CAUSA
 *    - Associa cada causa a uma justificativa
 *      detalhada, com quebras de linha.
 *********************************************/
justificativa(bateria_fraca, Justificativa) :-
    atom_concat('\n O sistema comparou 11,8V com o limite minimo de 12V\n e concluiu que a bateria ',
                'nao esta fornecendo voltagem adequada.\n Em paralelo, detectou-se que a luz de ',
                Parte1),
    atom_concat(Parte1,
                'bateria piscava, \n indicando suspeita no alternador. \n Portanto, prioriza-se ',
                Parte2),
    atom_concat(Parte2,
                'bateria fraca, mas, se recarregada \n e o problema continuar, passa a se  ',
                Parte3),
    atom_concat(Parte3,
                'investigar alternador.', Justificativa).

justificativa(alternador_defeituoso, Justificativa) :-
    atom_concat('A luz de bateria esta acesa, mas a bateria nao foi diagnosticada como fraca. ',
                'Isso sugere que o alternador pode estar defeituoso.', Justificativa).

justificativa(sistema_arrefecimento, Justificativa) :-
    atom_concat('A temperatura do motor esta acima de 100C, \ne a luz de check engine esta ',
                'acesa.\nIsso indica um problema no sistema de arrefecimento.\n', Justificativa).

justificativa(baixo_nivel_oleo, Justificativa) :-
    atom_concat('O nivel de oleo esta abaixo do minimo recomendado, \no que pode causar danos ',
                'ao motor.', Justificativa).

justificativa(vela_ignicao_defeituosa, Justificativa) :-
    atom_concat('Ha falha de ignicao frequente, mas a bateria esta em boas condicoes. Isso ',
                'sugere que as velas de ignicao podem estar defeituosas.', Justificativa).

justificativa(sensor_oxigenio_defeituoso, Justificativa) :-
    atom_concat('\nO sensor de oxigenio esta marcando um valor fora da faixa normal,\ne a luz de ',
                'check engine pisca em alta rotacao. \nIsso indica um problema no sensor de ',
                Parte1),
    atom_concat(Parte1,
                'oxigenio.', Justificativa).

justificativa(problema_injecao, Justificativa) :-
    atom_concat('Ha falha em alta rotacao, mas o sensor de oxigenio esta na faixa normal. ',
                'Isso sugere um problema no sistema de injecao.', Justificativa).

justificativa(problema_interno_motor, Justificativa) :-
    atom_concat('\nHa barulhos incomuns no motor, mas a temperatura esta normal\ne a luz de ',
                'check engine nao esta acesa.\nIsso sugere um problema interno no motor, ',
                Parte1),
    atom_concat(Parte1,
                'como bielas ou pistoes.\n', Justificativa).

justificativa(problema_transmissao, Justificativa) :-
    atom_concat('\nHa barulhos incomuns no motor, mas a temperatura esta normal\ne a luz de ',
                'check engine nao esta acesa.\nIsso sugere um problema na transmissao.', Justificativa).



/*********************************************
 * 7. EXEMPLOS DE CASOS DE TESTE
 *    - Cada cenário insere (assert) valores
 *      de sintomas e sensores, chama
 *      diagnosticar/0 e depois limpa o estado.
 * * (não mexer)
 *********************************************/
% Observação: Estes predicados são apenas exemplos
% de como testar. Ajuste conforme desejar.

caso_teste_1_partida_inconsistente :-
    write('=== Caso de Teste 1: Partida Inconsistente ==='), nl,
    limpar_estado,
    assertz(falha_ignicao),
    assertz(luz_bateria),
    assertz(bateria(11.8)),
    diagnosticar,
    limpar_estado.

caso_teste_2_superaquecimento :-
    write('=== Caso de Teste 2: Superaquecimento no Motor ==='), nl,
    limpar_estado,
    assertz(temperatura_motor(105)),
    assertz(nivel_oleo(1.5)),
    assertz(luz_check_engine),
    diagnosticar,
    limpar_estado.

caso_teste_3_motor_engasgado_altas_rotacoes :-
    write('=== Caso de Teste 3: Motor Engasgado em Altas Rotacoes ==='), nl,
    limpar_estado,
    assertz(rotacao_alta),
    assertz(luz_check_engine),
    assertz(sensor_oxigenio(1.0)), % valor fora do normal
    diagnosticar,
    limpar_estado.

caso_teste_4_ruidos_ao_acelerar :-
    write('=== Caso de Teste 4: Ruidos no Motor ao Acelerar ==='), nl,
    limpar_estado,
    assertz(barulho_incomum),
    assertz(temperatura_motor(90)),  % dentro da faixa normal
    diagnosticar,
    limpar_estado.

% Predicado para limpar o estado dinâmico antes/depois dos testes
limpar_estado :-
    retractall(bateria(_)),
    retractall(temperatura_motor(_)),
    retractall(nivel_oleo(_)),
    retractall(sensor_oxigenio(_)),
    retractall(luz_check_engine),
    retractall(luz_bateria),
    retractall(falha_ignicao),
    retractall(barulho_incomum),
    retractall(rotacao_alta).
    
:- initialization(main).

main :-
    write('=== Executando varios casos de teste ==='), nl,
    caso_teste_1_partida_inconsistente,
    caso_teste_2_superaquecimento,
    halt.