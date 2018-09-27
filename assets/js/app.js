// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import $ from "jquery";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import game_init from "./starter-game";
import React from 'react';
import ReactDOM from 'react-dom';



class Square extends React.Component {
    constructor(props) {
      super(props);
    }

    clicked(box) {
      this.props.click(box);
    }

    render() {
        return ( < div className = {
              "square" + (this.props.flipped ? ' flip' : '') + (this.props.checked ? ' matched' : '')
            }
            onClick = {
              () => this.clicked(this.props.box)
            }
            id = "appjs" >
            <
            div className = "hidden"
            id = "appjs" > ? < /div> <
            div className = "flippedOver"
            id = "appjs" > {
              (this.props.checked ? < span > & #10004;</span> : this.props.box)} < /div> </div>
    )
  }
}


class Gameboard extends React.Component {
  constructor(props) {
    super(props);
     this.state = {
                  letters: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
                  updatedTiles: [],
                  flippedTiles: [],
                  doubleTiles: [],
                  randomTiles: [],
                  score: 0,
                }; this.startGame();
              }


              getInitialState() {
                let initialState = _.extend(this.state, {
                  letters: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
                  updatedTiles: [],
                  flippedTiles: [],
                  doubleTiles: [],
                  randomTiles: [],
                  score: 0,
                });
                this.setState(initialState);
              }

              resetState() {
                this.setState(this.getInitialState());
                this.startGame();
                console.log("restart success");
                console.log(this.state);
              }

              shuffleArr(arr) {
                for (var i = arr.length - 1; i > 0; i--) {
                  var j = Math.floor(Math.random() * (i + 1));
                  var tem = arr[i];
                  arr[i] = arr[j];
                  arr[j] = tem;
                }
                return arr;
              }


              startGame() {
                this.state.doubleTiles = this.state.letters.concat(this.state.letters);
                this.state.randomTiles = this.shuffleArr(this.state.doubleTiles);
                this.state.randomTiles.map((element, index) => {
                  this.state.updatedTiles.push({
                    element,
                    flipped: false,
                    checked: false,
                  })
                });
              }

              handleClick(element, index) {
                if (this.state.flippedTiles.length == 2) {
                  setTimeout(() => {
                    this.lettersMatchOrNot();
                  }, 1000);
                } else {
                  this.pushletter(element, index);
                  if (this.state.flippedTiles.length == 2) {
                    setTimeout(() => {
                      this.lettersMatchOrNot()
                    }, 1000);
                  }
                }
              }


              lettersMatchOrNot() {
                let score = this.state.score;
                let updatedTiles = this.state.updatedTiles;
                console.log("check 1" + this.state.flippedTiles[0].element);
                console.log("check 2" + this.state.flippedTiles[1].element);
                // console.log("Check Here" + flippedTiles);
                if ((this.state.flippedTiles[0].element == this.state.flippedTiles[1].element) &&
                  (this.state.flippedTiles[0].index != this.state.flippedTiles[1].index)) {
                  updatedTiles[this.state.flippedTiles[0].index].checked = true;
                  updatedTiles[this.state.flippedTiles[1].index].checked = true;
                  this.setState({
                    score: this.state.score + 1
                  });
                  // score = this.state.score + 1;

                } else {
                  // console.log("Check 2" + flippedTiles);
                  updatedTiles[this.state.flippedTiles[0].index].flipped = false;
                  updatedTiles[this.state.flippedTiles[1].index].flipped = false;
                }
                this.setState({
                  updatedTiles,
                  flippedTiles: [],
                  // score,
                });
              }


              pushletter(element, index) {
                let box = {
                  element,
                  index
                }
                let updatedTiles = this.state.updatedTiles;
                let letters = this.state.flippedTiles;
                updatedTiles[index].flipped = true;
                letters.push(box)
                this.setState({
                  flippedTiles: letters,
                  updatedTiles: updatedTiles
                });
              }

              render() {
                return ( <
                    div >
                    <
                    h1 id = "heading" > Memory Game < /h1> <
                    div className = "gameboard"
                    id = "appjs" > {
                      this.state.updatedTiles.map((box, index) => {
                          return <Square box = {
                            box.element
                          }
                          click = {
                            () => {
                              this.handleClick(box.element, index)
                            }
                          }
                          flipped = {
                            box.flipped
                          }
                          checked = {
                            box.checked
                          }
                          />})} </div >

                          <
                          div className = "control-panel" >
                            <
                            h1 >
                            Score: {
                              this.state.score
                            } <
                            /h1>

                            <
                            button type = "button"
                          onClick = {
                              this.resetState.bind(this)
                            } > New Game < /button> <
                            /div> <
                            /div>

                        )
                      }
                    }

                    ReactDOM.render( < Gameboard / > , document.getElementById('root'));
                    // $(() => {
                    //   let root = $('#root')[0];
                    //   game_init(root);
                    // });
