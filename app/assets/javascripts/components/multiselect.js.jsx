var Multiselect = React.createClass({
    propTypes: {
        selection: React.PropTypes.array,
        removeFromSelection: React.PropTypes.func,
        hiddenField: React.PropTypes.string,
        backspaceTarget: React.PropTypes.number,
        removable: React.PropTypes.bool,
        buttonText: React.PropTypes.string,
        toggleModal: React.PropTypes.func
    },

    getDefaultProps: function() {
        return {
            selection: [],
            removable: false
        }
    },

    handleRemove: function(event) {
        this.props.removeFromSelection(parseInt(event.target.closest('.chip').getAttribute('data-id')));
    },

    render: function() {
        var selection = this.props.selection.map(function(selected, index) {
            return (
                <Chip
                    key={"selection-" + index}
                    index={index}
                    active={this.props.backspaceTarget === index}
                    label={selected.name}
                    handleRemove={this.props.removable ? this.handleRemove : null}
                    image={selected.image}/>
            );
        }.bind(this));

        if (this.props.buttonText) {
            var button = <a
                            onClick={this.props.toggleModal}
                            className="btn-floating btn-large waves-effect waves-light">
                            <i className="material-icons">{this.props.buttonText}</i>
                        </a>;
        }

        return (
            <div className='multiselect' ref='root'>
                <div className='selection-container valign-wrapper'>
                    {selection}
                </div>
                {button}
            </div>
        );
    },

    componentDidUpdate: function(prevProps, prevState) {
        if (this.props.selection !== prevProps.selection) {
            this.setState({ selection: this.props.selection });
        }
    }
});
