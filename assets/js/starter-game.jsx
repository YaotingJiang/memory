import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';


export default function game_init(root, channel) {
  ReactDOM.render(<Gameboard channel={channel}/>, root);
}


function MouseClick(params) {
  let state = params.state;
  return (<div><h1>Clicks: {state.clicks}</h1></div>);
}


function Restart(params) {
  let state = params.state;
  return(<div><button onClick={params.new}>Restart</button></div>);
}

class Gameboard extends React.Component {
constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
    clicks: 0,
    tiles: [],
    match: 0,
    selectedTile1: null,
    selectedTile2: null,
    players: [],
    };
    this.channel.join().receive("ok", this.gotView.bind(this))
    .receive("error", resp => { console.log("Unable to join", resp)});
  }

 gotView(view) {
  console.log("New view", view);
  this.setState(view.game);
 }

  resetState() {
    this.channel.push("new")
    .receive("ok", this.gotView.bind(this));
  }

  timeOut(view) {
    this.gotView(view);
    setTimeout(()=>{this.channel.push("matchOrNot").receive("ok", this.gotView.bind(this))}, 1000);
  }

  sendClick(tile) {
    this.channel.push("checkEquals", { tile: tile })
    .receive("ok", this.gotView.bind(this))
    .receive("matchOrNot", this.timeOut.bind(this));
 }

  render() {
    return (
      <div>
          <Squares state={this.state} checkEquals={this.sendClick.bind(this)} />
          <div className="control-panel">
            <h1>Clicks: {this.state.clicks}</h1>
            <button onClick={this.resetState.bind(this)}>Restart</button>
          </div>
      </div>
     );
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
            <div className="tile" key={index} onClick={() => params.checkEquals(tile)}>
              {show}
            </div>
          )
        });
        return(<div className="gameboard">{tiles}</div>)
}
