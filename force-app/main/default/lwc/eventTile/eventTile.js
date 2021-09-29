import { api, LightningElement } from 'lwc';

export default class EventTile extends LightningElement {

    @api event;
    @api imageUrl;

    handleClick(event) {
        event.preventDefault();
        const selectEvent = new CustomEvent('select', {
            detail: {
                eventId: this.event.Id
            }
        });
        this.dispatchEvent(selectEvent);
    }

    
}