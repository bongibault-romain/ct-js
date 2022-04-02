//
    @attribute entitytype (EventApplicableEntities)
        The asset type that is being added
    @attribute event (IScriptableEvent)
        The event to edit.

    @attribute [onchanged] (Riot function)
        The function is called whenever there was a change in the code.
        No arguments are passed as the [event] attribute is edited directly.

code-editor-scriptable.aCodeEditor(ref="root")
    script.
        this.on('mount', () => {
            var editorOptions = {
                language: 'typescript',
                lockWrapper: true
            };
            const makeVarDeclaration = () => {
                this.opts.event
            };
            setTimeout(() => {
                this.codeEditor = window.setupCodeEditor(
                    this.refs.root,
                    Object.assign({}, editorOptions, {
                        value: '',
                        wrapper: ['function onCreate(this: Copy) {', '}']
                    })
                );

                this.codeEditor.onDidChangeModelContent(() => {
                    this.currentEvent.code = this.codeEditor.getPureValue();
                });
                this.codeEditor.focus();
            }, 0);
        });
        this.on('unmount', () => {
            // Manually destroy code editors, to free memory
            this.codeEditors.dispose();
        });

        var cachedEvent = this.opts.event;
        this.on('update', () => {
            if (cachedEvent !== this.opts.event) {
                cachedEvent = this.opts.event;
            }
        })
