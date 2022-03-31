const coreCategories: Record<string, IEventCategory> = {
    lifecycle: {
        name: 'Lifecycle',
        icon: 'rotate-cw'
    },
    actions: {
        name: 'Actions',
        icon: 'airplay'
    },
    pointer: {
        name: 'Pointer events',
        icon: 'ui'
    }
};

const coreEvents = require('./coreEvents') as Record<string, IEventDeclaration>;

const events: Record<string, IEventDeclaration> = {
    // Basic, primitive events, aka lifecycle events
    ...coreEvents
};

interface IEventMenuEvent {
    eventKey: string,
    event: IEventDeclaration
}

interface IEventMenuSubmenu {
    key: string;
    category: IEventCategory;
    items: IEventMenuEvent[];
}
type EventMenu = IEventMenuSubmenu[];

const bakeCategories = function bakeCategories(entity: EventApplicableEntities): EventMenu {
    const menu = [];
    for (const categoryKey in coreCategories) {
        menu.push({
            key: categoryKey,
            category: coreCategories[categoryKey],
            items: [] as IEventMenuEvent[],
            core: true
        });
    }
    for (const eventKey in events) {
        if (!events[eventKey].applicable.includes(entity)) {
            continue;
        }
        const submenu = menu.find(section => {
            if (section.core === !events[eventKey].category.custom) {
                return section.key === events[eventKey].category.key;
            }
            // TODO: custom categories
            return false;
        });
        if (submenu) {
            submenu.items.push({
                eventKey,
                event: events[eventKey]
            });
        }
    }
    return menu;
};

export = {
    coreCategories,
    events,
    bakeCategories
};
