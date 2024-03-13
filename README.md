# Exemplo de Autenticação OAuth2 para a API John Deere em Ruby

Este projeto fornece um exemplo completo em Ruby para:
   * Obter um token de acesso OAuth2 via OIDC (OpenId Connect)
   * Usar um token de atualização para renovar seu próprio
   * Chamar as APIs da John Deere com seu token de acesso

## Requisitos
* Ruby 2.x
* Gem `faraday`

## Como iniciar este projeto
* Clone este repositório:
    * ```git clone git@github.com:seu-usuario/seu-repositorio.git```
* Instale as dependências
    * ```bundle install```

## Usando este projeto
* Em um terminal IRB, você precisará de algumas coisas
   * Um ClientId e Secret de sua aplicação em https://developer.deere.com
   * O retorno de chamada (callback) para sua aplicação precisa estar configurado para a URL deste aplicativo.

## Objetivo
* O objetivo desse projeto é capturar as médias de horímetros dos veículos e colocar em uma planinha em CSV para analisar os dados
