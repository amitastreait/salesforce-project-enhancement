import { LightningElement , api } from "lwc";
export default class LwcBuilderDemo extends LightningElement {
	@api
	recordId;
	@api
	componentTitle;
	@api
	objectApiName;
}