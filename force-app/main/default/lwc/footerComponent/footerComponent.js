import { LightningElement, wire } from 'lwc';
import fetchFooterContent from '@salesforce/apex/FooterComponentLWCService.fetchFooterContent';

export default class FooterComponent extends LightningElement {
    
    __footerContents;
    __errors;

    @wire(fetchFooterContent)
    wiredData({ error, data }) {
        if (data) {
            this.__errors = undefined;
            this.__footerContents = data;
        } else if (error) {
            console.error('Error:', error);
            this.__errors = error;
            this.__footerContents = undefined;
        }
    }
    
}