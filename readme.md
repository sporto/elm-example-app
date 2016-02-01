# An example SPA in Elm

Example application built for http://www.elm-tutorial.org/

## TODO

- Get initial data
  - Get list of players from server
  - Get list of perks from server
  - Get list of perksPlayers from server
- Edit player name
  - Validation for player name
  - Save player edit to server
- Edit player level
  - Save player level to server
- Add perk to player
  - Save perk-player to server
- Delete perk from player
  - Save perk-player deletion to server
- Search box for perks
- More server fixtures
- Tests?
- Add FA icons

Guide:

## Installing Webpack

- packages to install

npm install -S webpack
npm i -S webpack-dev-server
file-loader
css-loader
style-loader
extract-text-webpack-plugin
npm install -S elm-webpack-loader
basscss

- change 'src' in elm-package

## Running the application:

```
npm install
npm run dev
```

Open localhost:3000

