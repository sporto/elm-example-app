# An example SPA in Elm

An example Elm single page application built for http://www.elm-tutorial.org/

## This application uses

- StartApp for structure
- Hop for routing
- Webpack for building
- Basscss for css styles
- JsonServer for fake api

## This application demonstrate

- Elm architecture
- Routing
- Ajax requests and json parsing
- External CSS

## Setup

```
npm install
```

## Running the application:

In one terminal run the webpack dev server:

```
npm run dev
```

In another terminal run the fake api server:

```
npm run api
```

Open http://localhost:3000

## TODO

- Validation for player name

- Add perk to player
  - Save perk-player to server
- Delete perk from player
  - Save perk-player deletion to server
- Search box for perks
- More server fixtures
- Tests?
- Add FA icons
- Add player

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



