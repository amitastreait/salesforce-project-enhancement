import { api, LightningElement } from 'lwc';
import recordResponse from '@salesforce/apex/ContactUsLWCService.recordResponse';

export default class ContactUsComponent extends LightningElement {

    __emailMessage = {};
    @api eventId; // related task to the event
    @api organizerEmail; // email of the organizer
    @api organizerOwner; // owner of the organizer


    __isSpinnerActive = false;

    handleChange(event) {
        const field = event.target.name; // Name, Email, Message
        const value = event.target.value;
        this.__emailMessage[field] = value;
        /*
            {
                Name : '',
                Email : '',
                Subject : '',
                Message : ''
            }
        */
    }

    handleSend(event) {
        event.preventDefault();
        
        if(this.validateInput()){
            this.__isSpinnerActive = true;
            // call the apex class to record the response
            recordResponse({
                paramsMap : this.__emailMessage,
                emailAddress : this.organizerEmail,
                ownerId : this.organizerOwner,
                eventId : this.eventId
            })
            .then( (result) => {
                this.dispatchEvent(new CustomEvent('success', {
                    detail: 'success'
                }));
            })
            .catch(error => {
                // TODO Error handling
                console.error('Error : ', error);
            })
            .finally(() => {
                this.__isSpinnerActive = false;
            });
            
        }
    }

    handleCancel(event) {
        event.preventDefault();
        this.dispatchEvent(new CustomEvent('cancel', {
            detail: 'cancel'
        }));
    }

    validateInput() {

        const allValid = [...this.template.querySelectorAll('lightning-input')]
        .reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        const allValidMessage = [...this.template.querySelectorAll('lightning-textarea')]
        .reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);

        return allValid && allValidMessage;
    }
    
}