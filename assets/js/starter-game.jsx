import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Gameboard channel={channel}/>, root);
}

function Square(props) {
    // let box = props.box;
        return ( < div className = {
              "square" + (props.flipped ? ' flip' : '') + (props.checked ? ' matched' : '')
            }
            onClick = {
              () => props.click()
            }
            id = "appjs" >
            <
            div className = "hidden"
            id = "appjs" > ? < /div> <
            div className = "flippedOver"
            id = "appjs" > {
              (props.checked ? <span>&#10004;</span> : props.box)} < /div> </div>
    )
}


class Gameboard extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    // console.log("channel " + channel);
     this.state = {
                  // letters: ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'],
                  updatedTiles: [],
                  flippedTiles: [],
                  // doubleTiles: [],
                  // randomTiles: [],
                  score: 0,
                };
                this.channel.join()
                .receive("ok", this.gotView.bind(this))
                .receive("error", resp => { console.log("Unable to join", resp) });
              }

              gotView(view) {
                console.log("new view", view);
                this.setState(view.game);
              }

              sendClick(element, index) {
                console.log("sent!");
                // this.state.updatedTiles[index].element
                this.channel.push("checkEquals", {element: element, index: index})
                .recieve("ok", this.gotView.bind(this))
                .receive("checkEquals", resp => {console.log("not sending")});
              }

              resetState() {
                this.channel.push("new").receive("ok", this.gotView.bind(this));
              }

              handleClick(element, index) {
                // console.log("element " + element, "index " + index);
                // window.setTimeout(this.sendClick.bind(this), 1000);



                element = this.state.updatedTiles[index].letter
                console.log("element "  + element);
                console.log("check "  + this.state.updatedTiles[index].checked);
                console.log("flipped "  + this.state.updatedTiles[index].flipped);
                console.log("index "  + this.state.updatedTiles[index].index);
                // this.channel.push("checkEquals", {element: element, index: index}).receive("ok", this.gotView.bind(this));
                // window.setTimeout(this.sendClick.bind(this), 1000);
                // this.channel.push("checNotkEquals", {element: element, index: index}).receive("ok", this.gotView.bind(this))
                // this.channel.push("checkEquals", {element: element, index: index}).receive("ok", this.gotView.bind(this))
                setTimeout(()=>{this.channel.push("checkMatch", {}).receive("ok", this.gotView.bind(this))}, 1000);
                this.channel.push("checkEquals", {element: element, index: index}).receive("ok", this.gotView.bind(this));
                // window.setTimeout(this.sendClick.bind(this), 1000);
              }


              // lettersMatchOrNot() {
              //   this.channel.push("checkMatch").receive("ok", this.gotView.bind(this));
              // }

              render() {
                let square = _.map(this.state.updatedTiles, (box, index) => {
                  return <Square box={box.letter} click = {() => {this.handleClick(this.state.updatedTiles[index].letter, index)}}
                    flipped = {this.state.updatedTiles[index].flipped} checked = {this.state.updatedTiles[index].checked} key={index} />;
                })


                return (
                  <div>
                  <h1 id = "heading" > Memory Game < /h1>
                  <div className="gameboard">{square}</div>
                  <div className = "control-panel" >
                      <h1 >Score: {this.state.score}</h1>
                      <button type = "button" onClick = {this.resetState.bind(this)}>New Game</button>
                  </div>
                </div>)

              }
          }
