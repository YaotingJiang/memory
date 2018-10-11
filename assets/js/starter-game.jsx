import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';


export default function game_init(root, channel) {
  ReactDOM.render(<Gameboard channel={channel}/>, root);
}

class Gameboard extends React.Component {
constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
    clicks: 0,
    tiles: [],
    numOfmatch: 0,
    card1: null,
    card2: null,
    timeout: false,
    players: [],
    observers: [],
    };
    // this.gotView.bind(this)
    this.channel.join().receive("ok",
    () => {this.channel.push("addplayer", {}).receive("ok", this.gotView.bind(this))})
    .receive("error", resp => { console.log("Unable to join", resp)});
    this.channel.on("newview", this.gotView.bind(this))
  }

 gotView(view) {
  console.log("New view", view);
  console.log(`Timeout ${view.game.timeout}`);
  this.setState(view.game);
  //this.channel.push("matchOrNot").receive("ok", this.gotView.bind(this));
  if(this.state.timeout) {
    console.log("here");
    setTimeout(()=>{this.channel.push("cooled", {}).receive("ok", this.gotView.bind(this))}, 1000);
  }
 }

  resetState() {
    this.channel.push("new")
    .receive("ok", this.gotView.bind(this));
  }


  sendClick(tile) {
    if(!this.state.timeout) {
      this.channel.push("replaceTiles", { tile: tile })
      .receive("ok", this.gotView.bind(this));
    }
 }


  render() {
    let numplayer = this.state.players.length;
    console.log(numplayer);
    if(Object.keys(this.state.players).length < 2) {
      return (<h1>Waiting others to join</h1>);
    } else {
    return (
      <div>
          <div className = "playerInfo">
            <div className = "p1">
              <p>Player1: {this.state.players[0].name}</p>
              <p>Score: {this.state.players[0].score}</p>
            </div>
            <div className = "p2">
              <p>Player2: {this.state.players[1].name}</p>
              <p>Score: {this.state.players[1].score}</p>
            </div>
          </div>
          <Squares state={this.state} replaceTiles={this.sendClick.bind(this)} />
          <div className="control-panel">
            <h1>Clicks: {this.state.clicks}</h1>
            <button onClick={this.resetState.bind(this)}>Restart</button>
          </div>
      </div>
     );
    }
  }
}

function Squares(params) {
      let state = params.state;
      let tiles = _.map(state.tiles, (tile, index) => {
        let show;
        if(tile.tileStatus == 'flipped'){
           show = <span id = "letters">{tile.letter}</span>;
        }
        else if(tile.tileStatus == 'checked') {
           show = <span id = "checkmark">✓</span>;
        }
        else {
           show = <span id = "questionmark">?</span>;
        }
        return(
            <div className="tile" key={index} onClick={() => params.replaceTiles(tile)}>
              {show}
            </div>
          )
        });
        return(<div className="gameboard">{tiles}</div>)
}
