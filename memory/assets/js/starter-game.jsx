import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';

export default function game_init(root, channel) {
  ReactDOM.render(<Memory channel={channel} />, root);
}

function Square(props) {


   var c;
 if (props.hidden){
   c = null;
 }
  else {
    c = props.letter;
  } 
    return (
      
      <td key= {props.value}
        className="square"
        onClick={() => props.onClick()}
      >
        {c}
      </td>
    );
  }


class Memory extends React.Component{
  constructor(props) {
    super(props);
    this.channel = props.channel;

    this.state = {
	    letters: [],
	    first:  null,
	    second: null, 
	    present: [],
	    clicks: 0, 
	    clickDisaled: false

    };
	  this.channel
	      .join()
	      .receive("ok", this.got_view.bind(this))
	      .receive("error", resp => {console.log("Unable to join", resp);});
  }
  got_view(view) {
    console.log("new view", view);
    this.setState(view.game);
  }
  handleClick(i){
	 if (!this.state.clickDisabled){
	  this.channel.push("click", {index: i})
	  		.receive("ok", this.got_view.bind(this));
	  } }
 
	
  reset(){
	  this.channel.push("reset", {})
	  		.receive("ok", this.got_view.bind(this));
  }

  renderSquare(i) {
	  if (this.state.present[i]==null){
    		return <Square value={i} key={32+i} letter={this.state.letters[i]} hidden={true} onClick={()=>this.handleClick(i)}/>;}
	  // present[i]== null means the tile is completed.
	  else {
	  	return <Square value={i} key={32+i} letter={this.state.letters[i]} hidden={false} onClick={()=>{return;}}/>;
		 
	  }
  }
initRow(s, a){
	var tds= [];
	for (var j = 0; j < a; j ++){
		tds.push(this.renderSquare(s+j));

	}
	return tds;
}
  initSquare(){
	var rows = [];
  	for (var i = 0; i < 16; i +=4){
		rows.push(<tr key={i+16} className="broad-row">{this.initRow(i, 4)}</tr>);
		
	}
	return (<tbody key={"bd"}>{rows}</tbody>);
  
  
  }
checkMatch(){

		this.channel.push("check_match", {})
			.receive("ok", this.got_view.bind(this));
		
	
}
	render(){
	 if (this.state.first != null && this.state.second != null){
		this.checkMatch();}
	
	let numClicks = this.state.clicks;
		return (
	<div>
	<p>total clicks: {numClicks}</p>
	<table>
			{this.initSquare()}		
      </table>
	<button onClick = {()=>this.reset()}>Reset</button>
</div>
    );
	}


}


