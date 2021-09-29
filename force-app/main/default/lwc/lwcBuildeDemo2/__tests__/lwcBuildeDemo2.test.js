import { createElement } from "lwc";
import LwcBuildeDemo2 from "c/lwcBuildeDemo2";

// import { registerLdsTestWireAdapter } from '@salesforce/sfdx-lwc-jest';
// import { registerApexTestWireAdapter } from '@salesforce/sfdx-lwc-jest';

describe("c-lwc-builde-demo2", () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it("has component name on the header", () => {
        const element = createElement("c-lwc-builde-demo2", {
            is: LwcBuildeDemo2
        });
        document.body.appendChild(element);

        return Promise.resolve().then(() => {
            const componentHeader = element.shadowRoot.querySelector("h1");
            expect(componentHeader.textContent).toBe("lwcBuildeDemo2");
        });
    });
});