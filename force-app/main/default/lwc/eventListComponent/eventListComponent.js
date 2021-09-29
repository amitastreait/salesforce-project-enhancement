import { LightningElement, wire } from 'lwc';
import fetchUpComingEvents from '@salesforce/apex/EventListLWCService.fetchUpComingEvents';
import fetchPastEvents from '@salesforce/apex/EventListLWCService.fetchPastEvents';

import { NavigationMixin } from 'lightning/navigation';

import EventTitle from '@salesforce/resourceUrl/EventTitle';

export default class EventListComponent extends NavigationMixin( LightningElement ) {
    
    upcomingEvnets;
    pastEvents;
    __errors;
    isSpinner = false;

    images = {
        event : EventTitle
    }

    @wire(fetchUpComingEvents)
    wiredUpcomingEventsData({ error, data }) {
        if (data) {
            this.upcomingEvnets = data;
        } else if (error) {
            console.error('Error:', error);
            this.upcomingEvnets = undefined;
            this.__errors = error;
        }
    }

    @wire(fetchPastEvents)
    wiredPastEventsData({ error, data }) {
        if (data) {
            this.pastEvents = data;
        } else if (error) {
            console.error('Past Event Error:', error);
            this.__errors = error;
            this.pastEvents = undefined;
        }
    }

    handleEventClick = event => {

        event.preventDefault();
        let selectedEventId = event.detail.eventId;

        let navigationTarget = {
            type: 'comm__namedPage',
            attributes: {
                name: "eventDetails__c"
            },
            state : {
                eventId : selectedEventId,
                source  : 'eventListPage'
            }
        }
        
        this[NavigationMixin.Navigate](navigationTarget);
    }
}