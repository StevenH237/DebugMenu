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
    EntityList = {
      Label = {
        Inventory = function(...)
          return L.formatKey("%s in inventory of %s#%d", "menu.entityPicker.label.inventory", ...)
        end,
        WithPosition = function(...)
          return L.formatKey("%s at %d, %d", "menu.entityPicker.label.withPosition", ...)
        end
      },
      Title = L("Entity list", "menu.entityList.title")
    },
    EntityPicker = {
      Nearby = L("Nearby entities", "menu.entityPicker.nearby"),
      PrintEntity = L("Print entity", "menu.entityPicker.print"),
      Select = function(...) return L.formatKey("Entity ID: %d", "menu.entityPicker.select", ...) end,
      Title = L("Entity picker", "menu.entityPicker.title"),
      ViewEntity = L("View entity", "menu.entityPicker.view"),
    },
    EntityViewer = {
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
      Title = L("Entity viewer", "menu.entityViewer.title")
    },
    SearchEntities = {
      Components = function(...)
        return L.formatKey("Components: %d required, %d excluded", "menu.searchEntities.allComponents", ...)
      end,
      Name = L("Name", "menu.searchEntities.name"),
      Title = L("Entity search", "menu.searchEntities.title")
    },
    TableViewer = {
      Title = L("Table viewer", "menu.tableViewer.title")
    }
  }
}
