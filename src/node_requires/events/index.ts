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

const ctTypeToTSTypeMap = {
    integer: 'number',
    float: 'number',
    string: 'string',
    boolean: 'boolean',
    template: 'string | -1',
    room: 'string | -1',
    sound: 'string | -1',
    tandem: 'string | -1',
    font: 'string | -1',
    style: 'string | -1',
    texture: 'string | -1',
    action: 'Action'
};

const getEventByLib = (event: string, libName: string): IEventDeclaration =>
    events[`${libName}_${event}`];

const getArgumentsTypeScript = (event: IEventDeclaration): string => {
    let code = '';
    if (event.arguments) {
        for (const key in event.arguments) {
            code += `var ${key}: ${ctTypeToTSTypeMap[event.arguments[key].type]} = ${event.arguments[key].default || 'void 0'};`;
        }
    }
    return code;
};

export = {
    coreCategories,
    events,
    bakeCategories,
    getEventByLib,
    getArgumentsTypeScript
};
