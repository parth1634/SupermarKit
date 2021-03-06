var MultiselectForm = React.createClass({
    mixins: [ModalContainer],

    propTypes: {
        title: React.PropTypes.string,
        button: React.PropTypes.string,
        users: React.PropTypes.array,
        formElement: React.PropTypes.string.isRequired,
        modal: React.PropTypes.object.isRequired
    },

    handleSave: function(modalSelection) {
        document.getElementById(this.props.formElement).value = modalSelection.map(function(selected) {
            return selected.id;
        }).join(',');

        this.setState({
            modal: React.addons.update(
                this.state.modal,
                {
                    selection: {
                        $set: modalSelection
                    },
                }
            )
        }, this.toggleModalAndLoading);
    },

    render: function() {
        if (this.props.title) {
            var title = <h3>{this.props.title}</h3>;
        }

        return (
            <div className='multi-select-form'>
                <div>
                    {title}
                    <Multiselect
                        toggleModal={this.toggleModal}
                        buttonText={this.props.buttonText}
                        selection={this.state.modal.selection}/>
                </div>
                <div>
                    <Modal
                        {...this.state.modal}
                        {...this.props.modal}/>
                </div>
            </div>
        );
    }
});
