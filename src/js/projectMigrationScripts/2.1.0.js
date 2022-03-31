window.migrationProcess = window.migrationProcess || [];

window.migrationProcess.push({
    version: '2.1.0',
    process: project => new Promise(resolve => {
        const templateEventMap = {
            oncreate: 'core_OnCreate',
            onstep: 'core_OnStep',
            ondestroy: 'core_OnDestroy',
            ondraw: 'core_OnDraw'
        };
        const roomEventMap = {
            oncreate: 'core_OnRoomStart',
            onstep: 'core_OnStep',
            ondraw: 'core_OnDraw',
            onleave: 'core_OnRoomEnd'
        };
        for (const template of project.templates) {
            if (!template.events) {
                template.events = [];
                for (const key in templateEventMap) {
                    if (template[key]) {
                        template.events.push({
                            lib: 'core',
                            arguments: {},
                            code: template[key],
                            eventKey: templateEventMap[key]
                        });
                    }
                    delete template[key];
                }
            }
        }
        for (const room of project.rooms) {
            if (!room.events) {
                room.events = [];
                for (const key in roomEventMap) {
                    if (room[key]) {
                        room.events.push({
                            lib: 'core',
                            arguments: {},
                            code: room[key],
                            eventKey: roomEventMap[key]
                        });
                        delete room[key];
                    }
                }
            }
        }
        resolve();
    })
});
