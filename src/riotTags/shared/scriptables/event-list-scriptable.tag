//
    A tag that displays an editable event list and responds when a user selects a particular event.
    Type definitions for attributes described here are placed in node_requires/events folder
    and resources/IScriptable interface.

    @attribute events (IScriptableEvent[])
        The event list that is currently in the edited entity.
        This array is modified to add new events, edit existing ones.
    @attribute entitytype (EventApplicableEntities)
        The asset type that is being added
    @attribute [currentevent] (IScriptableEvent)
        Currently selected event.
        Defaults to the first event in the `events` attributes.

    @attribute onchanged (Riot function)
        A callback that is called whenever a new event was picked.
        It can happen as a direct response to a user input, or can happen,
        for example, when the previously selected event was deleted.

        The callback is passed the newly selected event (IScriptableEvent).

event-list-scriptable.flexfix(class="{opts.class}")
    .flexfix-body
        ui.aMenu
            li.flexrow(
                each="{event in opts.events}"
                class="{active: currentEvent === event}"
                onclick="{pickEvent}"
                title="{localizeField(allEvents[event.eventKey], 'hint')}"
            )
                svg.feather.act.nogrow
                    use(xlink:href="#{allEvents[event.eventKey].icon}")
                span.nogrow {event.lib === 'core' ? voc.coreEvents[event.eventKey] : parent.localizeField(allEvents[event.eventKey], 'name')}
                .aSpacer
                svg.feather.nogrow.anActionableIcon
                    use(xlink:href="#edit")
                svg.feather.nogrow.anActionableIcon
                    use(xlink:href="#trash")
    .flexrow.flexfix-footer
        docs-shortcut.nogrow(hidelabel="hidelabel" path="/ct.templates.html" button="true" wide="true" title="{voc.learnAboutTemplates}")
        .aSpacer.nogrow
        button
            svg.feather
                use(xlink:href="#plus")
                span {voc.addEvent}
    script.
        const eventsAPI = require('./data/node_requires/events');
        this.allEvents = eventsAPI.events;
        console.log(this.allEvents);

        this.namespace = 'common.scriptables';
        this.mixin(window.riotVoc);

        if (!this.opts.events) {
            console.error('event-list-scriptable was not provided with an `events` attribute.');
            console.warn(this);
        }
        if (!this.opts.entitytype) {
            console.error('event-list-scriptable was not provided with an `entitytype` attribute.');
            console.warn(this);
        }

        // Can turn into `undefined` if `events` is an empty array, this is ok
        this.currentEvent = this.opts.currentevent || this.opts.events[0];

        this.pickEvent = e => {
            const event = e.item.event;
            this.currentEvent = event;
            if (this.opts.onchanged) {
                this.opts.onchanged(event);
            }
        };
