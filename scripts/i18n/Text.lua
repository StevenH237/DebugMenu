return {
  Controls = {
    Menu = L("Open debug menu", "controls.menu")
  },
  Menu = {
    Close = L("Close menu", "menu.close"),
    Debug = {
      Title = L("Debug menu", "menu.debug.title")
    },
    EntityDoesntExist = {
      Title = L("Error", "menu.entityDoesntExist.title")
    },
    EntityPicker = {
      Label = {
        Default = function(...) return L.formatKey("%s#%d", "menu.entityPicker.label.default", ...) end,
        Inventory = function(...)
          return L.formatKey("%s#%d in inventory of %s#%d", "menu.entityPicker.label.inventory", ...)
        end,
        NonExistent = function(...)
          return L.formatKey("Entity #%d does not exist", "menu.entityPicker.label.nonexistent", ...)
        end,
        WithPosition = function(...)
          return L.formatKey("%s#%d at %d, %d", "menu.entityPicker.label.withPosition", ...)
        end
      },
      Select = function(...) return L.formatKey("Entity ID: %d", "menu.entityPicker.select", ...) end,
      PrintEntity = L("Print entity", "menu.entityPicker.print"),
      Title = L("Entity picker", "menu.entityPicker.title"),
      ViewEntity = L("View entity", "menu.entityPicker.view"),
    },
    EntityViewer = {
      Title = L("Entity viewer", "menu.entityViewer.title")
    },
    TableViewer = {
      Title = L("Table viewer", "menu.tableViewer.title")
    }
  }
}
